import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/calendar/calendar.dart';
import 'package:timeshare/data/event/event.dart';

class CalendarRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CalendarRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : firestore = firestore ?? FirebaseFirestore.instance,
      auth = auth ?? FirebaseAuth.instance;

  ///provides a future of all available calendars for viewing
  ///Defaults to using current user
  Future<List<Calendar>> getAllAvailableCalendars({String? uid}) async {
    uid = uid ?? auth.currentUser?.uid;
    if (uid == null) return [];

    final ownedSnapshot =
        await firestore
            .collection('calendars')
            .where('owner', isEqualTo: uid)
            .get();

    final sharedSnapshot =
        await firestore
            .collection('calendars')
            .where('sharedWith', arrayContains: uid)
            .get();

    final combined = [...ownedSnapshot.docs, ...sharedSnapshot.docs];
    return combined.map((doc) {
      return Calendar.fromJson(doc.data());
    }).toList();
  }

  Future<void> addCalendar(Calendar calendar) async {
    final docRef = firestore.collection('calendars').doc(calendar.id);
    await docRef.set(calendar.toJson());
  }

  ///Adds an event to the firestore calendar given.
  Future<void> addEventToCalendar({
    required String calendarId,
    required Event event,
  }) async {
    final docRef = firestore.collection('calendars').doc(calendarId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception("Calendar not found");
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
    print(' -updating the calendar in firestore...');
    await docRef.set(updatedCalendar.toJson());
    print(' -Finished updating!');
  }

  ///removes an event from the firestore calendar given.
  Future<void> removeEventFromCalendar({
    required String calendarId,
    required Event event,
  }) async {
    final docRef = FirebaseFirestore.instance
        .collection('calendars')
        .doc(calendarId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception("Calendar not found");
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
  }

  ///Makes a new calendar in the firestore
  Future<void> createCalendar(Calendar calendar) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    await firestore
        .collection('calendars')
        .doc(calendar.id)
        .set(calendar.toJson());
  }

  ///Shares a calendar with a user
  Future<void> shareCalendar(
    String calendarId,
    String targetUid,
    bool share,
  ) async {
    final doc = FirebaseFirestore.instance
        .collection('calendars')
        .doc(calendarId);

    await doc.update({
      'sharedWith':
          share
              ? FieldValue.arrayUnion([targetUid])
              : FieldValue.arrayRemove([targetUid]),
    });
  }

  Future<Calendar?> getCalendarById(String calendarId) async {
    final doc = firestore.collection('calendars').doc(calendarId);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      print('calendar not found :(');
      return null;
    }
    return Calendar.fromJson(snapshot.data()!);
  }

  Future<void> unshareCalendar(String calendarId, String targetUID) async {
    final doc = firestore.collection('calendars').doc(calendarId);

    await doc.update({
      'sharedWith': FieldValue.arrayRemove([targetUID]),
    });
  }

  Future<void> deleteCalendar(String calendarId) async {
    final ref = firestore.collection('calendars').doc(calendarId);
    final snapshot = await ref.get();
    if (!snapshot.exists) throw Exception("Calendar not found.");
    final data = snapshot.data();
    if (data?['ownerId'] != auth.currentUser!.uid) {
      throw Exception('You are not the owner of the calendar.');
    }

    await ref.delete();
  }
}
