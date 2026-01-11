import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/repo/firebase_repo.dart';

import '../../fixtures/mock_firebase.dart';
import '../../fixtures/test_data.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late FirebaseRepository repo;

  setUp(() async {
    firestore = await MockFirebaseSetup.createSeededFirestore();
    auth = MockFirebaseSetup.createMockAuth(signedIn: true);
    repo = FirebaseRepository(firestore: firestore, auth: auth);
  });

  group('FirebaseRepository - getAllAvailableCalendars', () {
    test('returns owned calendars', () async {
      final calendars = await repo.getAllAvailableCalendars();

      expect(calendars.isNotEmpty, true);
      expect(
        calendars.any((c) => c.id == TestData.testCalendar.id),
        true,
      );
    });

    test('returns empty list when signed out', () async {
      final signedOutAuth = MockFirebaseSetup.createMockAuth(signedIn: false);
      final signedOutRepo = FirebaseRepository(
        firestore: firestore,
        auth: signedOutAuth,
      );

      final calendars = await signedOutRepo.getAllAvailableCalendars();

      expect(calendars, isEmpty);
    });

    test('includes shared calendars', () async {
      final calendars = await repo.getAllAvailableCalendars();

      expect(
        calendars.any((c) => c.id == TestData.sharedCalendar.id),
        true,
      );
    });
  });

  group('FirebaseRepository - watchAllAvailableCalendars', () {
    test('emits calendars', () async {
      final stream = repo.watchAllAvailableCalendars();

      await expectLater(
        stream,
        emits(isA<List<Calendar>>()),
      );
    });

    test('emits empty list when signed out', () async {
      final signedOutAuth = MockFirebaseSetup.createMockAuth(signedIn: false);
      final signedOutRepo = FirebaseRepository(
        firestore: firestore,
        auth: signedOutAuth,
      );

      final stream = signedOutRepo.watchAllAvailableCalendars();

      await expectLater(
        stream,
        emits(isEmpty),
      );
    });
  });

  group('FirebaseRepository - createCalendar', () {
    test('creates calendar in Firestore', () async {
      final newCalendar = Calendar(
        id: 'test-user-123_New Calendar',
        owner: 'test-user-123',
        name: 'New Calendar',
      );

      await repo.createCalendar(newCalendar);

      final doc = await firestore
          .collection('calendars')
          .doc(newCalendar.id)
          .get();

      expect(doc.exists, true);
      expect(doc.data()?['name'], 'New Calendar');
    });

    test('does nothing when not logged in', () async {
      final signedOutAuth = MockFirebaseSetup.createMockAuth(signedIn: false);
      final signedOutRepo = FirebaseRepository(
        firestore: firestore,
        auth: signedOutAuth,
      );

      final newCalendar = Calendar(
        id: 'should-not-create',
        owner: 'none',
        name: 'Should Not Create',
      );

      await signedOutRepo.createCalendar(newCalendar);

      final doc = await firestore
          .collection('calendars')
          .doc(newCalendar.id)
          .get();

      expect(doc.exists, false);
    });
  });

  group('FirebaseRepository - addEvent', () {
    test('adds event to owned calendar', () async {
      final event = Event(
        id: 'new-test-event',
        name: 'New Test Event',
        time: DateTime.utc(2024, 8, 1, 10, 0),
        calendarId: TestData.testCalendar.id,
        color: Colors.purple,
      );

      await repo.addEvent(TestData.testCalendar.id, event);

      final doc = await firestore
          .collection('calendars')
          .doc(TestData.testCalendar.id)
          .collection('events')
          .doc(event.id)
          .get();

      expect(doc.exists, true);
      expect(doc.data()?['name'], 'New Test Event');
    });

    test('throws when user not logged in', () async {
      final signedOutAuth = MockFirebaseSetup.createMockAuth(signedIn: false);
      final signedOutRepo = FirebaseRepository(
        firestore: firestore,
        auth: signedOutAuth,
      );

      final event = Event(
        id: 'unauthorized-event',
        name: 'Unauthorized Event',
        time: DateTime.utc(2024, 8, 1),
        calendarId: TestData.testCalendar.id,
      );

      expect(
        () => signedOutRepo.addEvent(TestData.testCalendar.id, event),
        throwsA(isA<Exception>()),
      );
    });

    test('throws when user not authorized', () async {
      final otherAuth = MockFirebaseAuth(
        mockUser: MockUser(uid: 'unauthorized-user'),
        signedIn: true,
      );
      final otherRepo = FirebaseRepository(
        firestore: firestore,
        auth: otherAuth,
      );

      final event = Event(
        id: 'unauthorized-event',
        name: 'Unauthorized Event',
        time: DateTime.utc(2024, 8, 1),
        calendarId: TestData.testCalendar.id,
      );

      expect(
        () => otherRepo.addEvent(TestData.testCalendar.id, event),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('FirebaseRepository - deleteEvent', () {
    test('removes event from calendar', () async {
      // Get initial events
      final eventsBefore = await repo.getEventsForCalendar(TestData.testCalendar.id);
      final eventToRemove = eventsBefore.first;

      await repo.deleteEvent(TestData.testCalendar.id, eventToRemove.id);

      final eventsAfter = await repo.getEventsForCalendar(TestData.testCalendar.id);

      expect(eventsAfter.length, eventsBefore.length - 1);
    });
  });

  group('FirebaseRepository - getEventsForCalendar', () {
    test('returns events for calendar', () async {
      final events = await repo.getEventsForCalendar(TestData.testCalendar.id);

      expect(events.isNotEmpty, true);
      expect(events.any((e) => e.name == TestData.testEvent.name), true);
    });

    test('returns empty for calendar with no events', () async {
      final events = await repo.getEventsForCalendar(TestData.emptyCalendar.id);

      expect(events, isEmpty);
    });
  });

  group('FirebaseRepository - watchEventsForCalendar', () {
    test('streams events for calendar', () async {
      final stream = repo.watchEventsForCalendar(TestData.testCalendar.id);

      await expectLater(
        stream,
        emits(isA<List<Event>>()),
      );
    });
  });

  group('FirebaseRepository - shareCalendar', () {
    test('adds user to sharedWith list', () async {
      await repo.shareCalendar(
        TestData.testCalendar.id,
        'new-shared-user',
        true,
      );

      final doc = await firestore
          .collection('calendars')
          .doc(TestData.testCalendar.id)
          .get();

      final sharedWith = List<String>.from(doc.data()?['sharedWith'] ?? []);
      expect(sharedWith.contains('new-shared-user'), true);
    });

    test('removes user from sharedWith list', () async {
      // First share with a user
      await repo.shareCalendar(
        TestData.testCalendar.id,
        'temp-user',
        true,
      );

      // Then unshare
      await repo.shareCalendar(
        TestData.testCalendar.id,
        'temp-user',
        false,
      );

      final doc = await firestore
          .collection('calendars')
          .doc(TestData.testCalendar.id)
          .get();

      final sharedWith = List<String>.from(doc.data()?['sharedWith'] ?? []);
      expect(sharedWith.contains('temp-user'), false);
    });

    test('throws when non-owner tries to share', () async {
      final otherAuth = MockFirebaseAuth(
        mockUser: MockUser(uid: 'non-owner'),
        signedIn: true,
      );
      final otherRepo = FirebaseRepository(
        firestore: firestore,
        auth: otherAuth,
      );

      expect(
        () => otherRepo.shareCalendar(
          TestData.testCalendar.id,
          'some-user',
          true,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('throws when not logged in', () async {
      final signedOutAuth = MockFirebaseSetup.createMockAuth(signedIn: false);
      final signedOutRepo = FirebaseRepository(
        firestore: firestore,
        auth: signedOutAuth,
      );

      expect(
        () => signedOutRepo.shareCalendar(
          TestData.testCalendar.id,
          'some-user',
          true,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('FirebaseRepository - deleteCalendar', () {
    test('deletes owned calendar', () async {
      // Create a calendar to delete
      final calToDelete = Calendar(
        id: 'test-user-123_To Delete',
        owner: 'test-user-123',
        name: 'To Delete',
      );
      await repo.createCalendar(calToDelete);

      await repo.deleteCalendar(calToDelete.id);

      final doc = await firestore
          .collection('calendars')
          .doc(calToDelete.id)
          .get();

      expect(doc.exists, false);
    });

    test('throws when non-owner tries to delete', () async {
      final otherAuth = MockFirebaseAuth(
        mockUser: MockUser(uid: 'non-owner'),
        signedIn: true,
      );
      final otherRepo = FirebaseRepository(
        firestore: firestore,
        auth: otherAuth,
      );

      expect(
        () => otherRepo.deleteCalendar(TestData.testCalendar.id),
        throwsA(isA<Exception>()),
      );
    });

    test('throws when not logged in', () async {
      final signedOutAuth = MockFirebaseSetup.createMockAuth(signedIn: false);
      final signedOutRepo = FirebaseRepository(
        firestore: firestore,
        auth: signedOutAuth,
      );

      expect(
        () => signedOutRepo.deleteCalendar(TestData.testCalendar.id),
        throwsA(isA<Exception>()),
      );
    });

    test('throws when calendar not found', () async {
      expect(
        () => repo.deleteCalendar('nonexistent-calendar'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('FirebaseRepository - getCalendarById', () {
    test('returns calendar when found', () async {
      final calendar = await repo.getCalendarById(TestData.testCalendar.id);

      expect(calendar, isNotNull);
      expect(calendar!.id, TestData.testCalendar.id);
    });

    test('returns null when not found', () async {
      final calendar = await repo.getCalendarById('nonexistent-id');

      expect(calendar, isNull);
    });
  });
}
