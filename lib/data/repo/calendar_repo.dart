import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeshare/data/calendar/calendar.dart';

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

  Future<void> saveCalendar(Calendar calendar) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    await firestore
        .collection('calendars')
        .doc(calendar.id)
        .set(calendar.toJson());
  }

  Future<void> shareCalendar(String calendarId, String targetUID) async {
    final doc = FirebaseFirestore.instance
        .collection('calendars')
        .doc(calendarId);

    await doc.update({
      'sharedWith': FieldValue.arrayUnion([targetUID]),
    });
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
