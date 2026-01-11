// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';

class FirebaseRepository extends CalendarRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FirebaseRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : firestore = firestore ?? FirebaseFirestore.instance,
      auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _calendars =>
      firestore.collection('calendars');

  /// Helper to get the events subcollection for a calendar.
  CollectionReference<Map<String, dynamic>> _eventsRef(String calendarId) =>
      _calendars.doc(calendarId).collection('events');

  /// Verifies the current user has access to the given calendar.
  /// User must be the owner or in the sharedWith list.
  Future<void> _verifyCalendarAccess(String calendarId) async {
    final currentUid = auth.currentUser?.uid;
    if (currentUid == null) {
      throw Exception('You must be logged in to perform this action.');
    }

    final snapshot = await _calendars.doc(calendarId).get();
    if (!snapshot.exists || snapshot.data() == null) {
      throw Exception('Calendar not found.');
    }

    final data = snapshot.data()!;
    final owner = data['owner'] as String?;
    final sharedWith =
        (data['sharedWith'] as List<dynamic>?)?.cast<String>() ?? [];

    if (owner != currentUid && !sharedWith.contains(currentUid)) {
      throw Exception('You do not have permission to modify this calendar.');
    }
  }

  // ============ Calendar Operations ============

  @override
  Stream<List<Calendar>> watchAllAvailableCalendars({String? uid}) {
    uid = uid ?? auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    final ownedStream = _calendars
        .where('owner', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Calendar.fromJson(doc.data());
            }).toList());

    final sharedStream = _calendars
        .where('sharedWith', arrayContains: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Calendar.fromJson(doc.data());
            }).toList());

    // Combine streams using rxdart
    return Rx.combineLatest2(ownedStream, sharedStream,
        (List<Calendar> owned, List<Calendar> shared) {
      final seenIds = <String>{};
      final combined = <Calendar>[];

      for (final calendar in owned) {
        if (!seenIds.contains(calendar.id)) {
          seenIds.add(calendar.id);
          combined.add(calendar);
        }
      }

      for (final calendar in shared) {
        if (!seenIds.contains(calendar.id)) {
          seenIds.add(calendar.id);
          combined.add(calendar);
        }
      }

      return combined;
    });
  }

  @override
  Future<List<Calendar>> getAllAvailableCalendars({String? uid}) async {
    uid = uid ?? auth.currentUser?.uid;
    if (uid == null) return [];

    final ownedSnapshot =
        await _calendars.where('owner', isEqualTo: uid).get();

    final sharedSnapshot =
        await _calendars.where('sharedWith', arrayContains: uid).get();

    final seenIds = <String>{};
    final combined = <Calendar>[];

    for (final doc in ownedSnapshot.docs) {
      final calendar = Calendar.fromJson(doc.data());
      if (!seenIds.contains(calendar.id)) {
        seenIds.add(calendar.id);
        combined.add(calendar);
      }
    }

    for (final doc in sharedSnapshot.docs) {
      final calendar = Calendar.fromJson(doc.data());
      if (!seenIds.contains(calendar.id)) {
        seenIds.add(calendar.id);
        combined.add(calendar);
      }
    }

    return combined;
  }

  @override
  Future<void> createCalendar(Calendar calendar) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    await _calendars.doc(calendar.id).set(calendar.toJson());
  }

  @override
  Future<Calendar?> getCalendarById(String calendarId) async {
    final snapshot = await _calendars.doc(calendarId).get();
    if (!snapshot.exists) return null;
    return Calendar.fromJson(snapshot.data()!);
  }

  @override
  Future<void> shareCalendar(
    String calendarId,
    String targetUid,
    bool share,
  ) async {
    final currentUid = auth.currentUser?.uid;
    if (currentUid == null) {
      throw Exception('You must be logged in to share a calendar.');
    }

    final doc = _calendars.doc(calendarId);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      throw Exception('Calendar not found.');
    }

    final data = snapshot.data();
    if (data?['owner'] != currentUid) {
      throw Exception('Only the calendar owner can modify sharing settings.');
    }

    await doc.update({
      'sharedWith': share
          ? FieldValue.arrayUnion([targetUid])
          : FieldValue.arrayRemove([targetUid]),
    });
  }

  @override
  Future<void> deleteCalendar(String calendarId) async {
    final currentUid = auth.currentUser?.uid;
    if (currentUid == null) {
      throw Exception('You must be logged in to delete a calendar.');
    }

    final ref = _calendars.doc(calendarId);
    final snapshot = await ref.get();

    if (!snapshot.exists) throw Exception('Calendar not found.');

    final data = snapshot.data();
    if (data?['owner'] != currentUid) {
      throw Exception('You are not the owner of the calendar.');
    }

    // Cascade delete: remove all events first
    await deleteAllEventsForCalendar(calendarId);

    // Then delete the calendar document
    await ref.delete();
  }

  // ============ Event Operations (Subcollection) ============

  @override
  Stream<List<Event>> watchEventsForCalendar(String calendarId) {
    return _eventsRef(calendarId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Ensure id is set from document ID if not in data
        if (!data.containsKey('id')) {
          data['id'] = doc.id;
        }
        // Set calendarId from the parent path
        data['calendarId'] = calendarId;
        return Event.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<List<Event>> watchEventsForCalendars(List<String> calendarIds) {
    if (calendarIds.isEmpty) return Stream.value([]);

    final streams = calendarIds.map((id) => watchEventsForCalendar(id));
    return Rx.combineLatestList(streams).map((lists) {
      return lists.expand((list) => list).toList();
    });
  }

  @override
  Future<List<Event>> getEventsForCalendar(String calendarId) async {
    final snapshot = await _eventsRef(calendarId).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      if (!data.containsKey('id')) {
        data['id'] = doc.id;
      }
      // Set calendarId from the parent path
      data['calendarId'] = calendarId;
      return Event.fromJson(data);
    }).toList();
  }

  @override
  Future<void> addEvent(String calendarId, Event event) async {
    await _verifyCalendarAccess(calendarId);
    await _eventsRef(calendarId).doc(event.id).set(event.toJson());
  }

  @override
  Future<void> updateEvent(String calendarId, Event event) async {
    await _verifyCalendarAccess(calendarId);
    await _eventsRef(calendarId).doc(event.id).set(event.toJson());
  }

  @override
  Future<void> deleteEvent(String calendarId, String eventId) async {
    await _verifyCalendarAccess(calendarId);
    await _eventsRef(calendarId).doc(eventId).delete();
  }

  @override
  Future<void> deleteAllEventsForCalendar(String calendarId) async {
    final eventsSnapshot = await _eventsRef(calendarId).get();

    if (eventsSnapshot.docs.isEmpty) return;

    // Batch delete all events (Firestore batches are limited to 500 ops)
    final batch = firestore.batch();
    for (final doc in eventsSnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
