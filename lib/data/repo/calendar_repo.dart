// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';

class CalendarRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CalendarRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : firestore = firestore ?? FirebaseFirestore.instance,
      auth = auth ?? FirebaseAuth.instance;

  /// Provides a stream of all available calendars for viewing.
  /// Automatically updates when calendars change in Firestore.
  /// Defaults to using current user.
  Stream<List<Calendar>> watchAllAvailableCalendars({String? uid}) {
    uid = uid ?? auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    // Watch owned calendars
    final ownedStream = firestore
        .collection('calendars')
        .where('owner', isEqualTo: uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            print('FIREBASE READ: calendar from ownedStream');
            return Calendar.fromJson(doc.data());
          }).toList(),
        );

    // Watch shared calendars
    final sharedStream = firestore
        .collection('calendars')
        .where('sharedWith', arrayContains: uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            print('FIREBASE READ: calendar from ownedStream');
            return Calendar.fromJson(doc.data());
          }).toList(),
        );

    // Combine both streams using StreamController
    final controller = StreamController<List<Calendar>>();
    final seenIds = <String>{};
    List<Calendar> ownedCalendars = [];
    List<Calendar> sharedCalendars = [];

    void emitCombined() {
      final combined = <Calendar>[];
      seenIds.clear();

      // Add owned calendars first
      for (final calendar in ownedCalendars) {
        if (!seenIds.contains(calendar.id)) {
          seenIds.add(calendar.id);
          combined.add(calendar);
        }
      }

      // Add shared calendars (avoiding duplicates)
      for (final calendar in sharedCalendars) {
        if (!seenIds.contains(calendar.id)) {
          seenIds.add(calendar.id);
          combined.add(calendar);
        }
      }

      controller.add(combined);
    }

    final ownedSub = ownedStream.listen((calendars) {
      ownedCalendars = calendars;
      emitCombined();
    });

    final sharedSub = sharedStream.listen((calendars) {
      sharedCalendars = calendars;
      emitCombined();
    });

    controller.onCancel = () {
      ownedSub.cancel();
      sharedSub.cancel();
    };

    return controller.stream;
  }

  /// Provides a future of all available calendars for viewing.
  /// Defaults to using current user.
  /// Kept for backwards compatibility or one-time fetches.
  Future<List<Calendar>> getAllAvailableCalendars({String? uid}) async {
    uid = uid ?? auth.currentUser?.uid;
    if (uid == null) return [];

    final ownedSnapshot = await firestore
        .collection('calendars')
        .where('owner', isEqualTo: uid)
        .get();

    final sharedSnapshot = await firestore
        .collection('calendars')
        .where('sharedWith', arrayContains: uid)
        .get();

    final combined = [...ownedSnapshot.docs, ...sharedSnapshot.docs];
    return combined.map((doc) {
      return Calendar.fromJson(doc.data());
    }).toList();
  }

  /// Adds a given calendar object to the Firestore.
  Future<void> addCalendar(Calendar calendar) async {
    final docRef = firestore.collection('calendars').doc(calendar.id);
    await docRef.set(calendar.toJson());
    print('FIREBASE READ: adding calendar');
  }

  /// Adds an event to the firestore calendar given.
  Future<void> addEventToCalendar({
    required String calendarId,
    required Event event,
  }) async {
    final docRef = firestore.collection('calendars').doc(calendarId);
    final snapshot = await docRef.get();

    if (!snapshot.exists || snapshot.data() == null) {
      throw Exception('Calendar not found');
    }

    // Get the existing calendar data
    final calendar = Calendar.fromJson(snapshot.data()!);

    final normalizedDay = normalizeDate(event.time);

    // Add the event to the day's list
    final updatedEvents = Map<DateTime, List<Event>>.from(calendar.events);
    updatedEvents.update(
      normalizedDay,
      (list) => [...list, event],
      ifAbsent: () => [event],
    );

    // Create updated calendar
    final updatedCalendar = calendar.copyWith(events: updatedEvents);

    // Write back to Firestore
    print('FIREBASE WRITE: adding event to calendar');
    await docRef.set(updatedCalendar.toJson());
    print(' -Finished updating!');
  }

  /// Removes a given event from a given calendar.
  Future<void> removeEventFromCalendar({
    required String calendarId,
    required Event event,
  }) async {
    print(
      'FIREBASE READ: removing event ${event.name} from calendar $calendarId...',
    );

    final docRef = FirebaseFirestore.instance
        .collection('calendars')
        .doc(calendarId);
    final snapshot = await docRef.get();

    if (!snapshot.exists || snapshot.data() == null) {
      throw Exception('Failed to find calendar $calendarId');
    }

    final calendarData = snapshot.data()!;
    final calendar = Calendar.fromJson(calendarData);

    final normalizedDay = normalizeDate(event.time);
    final currentEvents = calendar.events[normalizedDay] ?? [];

    final updatedEventList = currentEvents.where((e) => e != event).toList();
    final updatedEvents = Map<DateTime, List<Event>>.from(calendar.events);

    if (updatedEventList.isEmpty) {
      updatedEvents.remove(normalizedDay);
    } else {
      updatedEvents[normalizedDay] = updatedEventList;
    }

    final updatedCalendar = calendar.copyWith(events: updatedEvents);

    await docRef.set(updatedCalendar.toJson());
    print('Calendar $calendarId had ${event.name} removed successfully.');
  }

  /// Makes a new calendar in the firestore
  Future<void> createCalendar(Calendar calendar) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    print('FIRESTORE WRITE: Create calendar');
    await firestore
        .collection('calendars')
        .doc(calendar.id)
        .set(calendar.toJson());
  }

  /// Shares a calendar with a user
  Future<void> shareCalendar(
    String calendarId,
    String targetUid,
    bool share,
  ) async {
    final doc = FirebaseFirestore.instance
        .collection('calendars')
        .doc(calendarId);

    await doc.update({
      'sharedWith': share
          ? FieldValue.arrayUnion([targetUid])
          : FieldValue.arrayRemove([targetUid]),
    });
    print('FIRESTORE WRITE: update calendar sharing');
  }

  /// Retreive a calendar by ID
  Future<Calendar?> getCalendarById(String calendarId) async {
    final doc = firestore.collection('calendars').doc(calendarId);
    final snapshot = await doc.get();
    print('FIRESTORE READ: getting calendar by ID');
    if (!snapshot.exists) {
      print('calendar not found :(');
      return null;
    }
    return Calendar.fromJson(snapshot.data()!);
  }

  /// Stop sharing a calendar with a given friend.
  /// PHASED OUT: retained if needed to revert
  // Future<void> unshareCalendar(String calendarId, String targetUID) async {
  //   final doc = firestore.collection('calendars').doc(calendarId);
  //
  //   await doc.update({
  //     'sharedWith': FieldValue.arrayRemove([targetUID]),
  //   });
  // }

  /// Deletes a calendar. Only the owner can delete a calendar.
  Future<void> deleteCalendar(String calendarId) async {
    final ref = firestore.collection('calendars').doc(calendarId);
    final snapshot = await ref.get();
    print('FIRESTORE READ: get $calendarId for deletion');
    if (!snapshot.exists) throw Exception('Calendar not found.');
    final data = snapshot.data();
    if (data?['ownerId'] != auth.currentUser!.uid) {
      throw Exception('You are not the owner of the calendar.');
    }

    await ref.delete();
    print('FIRESTORE WRITE: deleted $calendarId');
  }
}
