import 'package:flutter/material.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/models/user/app_user.dart';

/// Test data fixtures for unit and widget tests.
class TestData {
  // Common test IDs
  static const testUserId = 'test-user-123';
  static const testCalendarId = 'test-user-123_Test Calendar';
  static const testEventId = 'event-1';

  // Test users
  static final testUser = AppUser(
    uid: 'test-user-123',
    email: 'test@example.com',
    displayName: 'Test User',
    joinedAt: DateTime(2024, 1, 15),
    friends: ['friend-user-456'],
  );

  static final friendUser = AppUser(
    uid: 'friend-user-456',
    email: 'friend@example.com',
    displayName: 'Friend User',
    joinedAt: DateTime(2024, 2, 20),
    friends: ['test-user-123'],
  );

  static final otherUser = AppUser(
    uid: 'other-user-789',
    email: 'other@example.com',
    displayName: 'Other User',
    joinedAt: DateTime(2024, 3, 10),
    friends: [],
  );

  // Test events
  static final testEvent = Event(
    id: 'event-1',
    name: 'Test Event',
    time: DateTime.utc(2024, 6, 15, 10, 0),
    color: Colors.blue,
    shape: BoxShape.circle,
  );

  static final testEvent2 = Event(
    id: 'event-2',
    name: 'Second Event',
    time: DateTime.utc(2024, 6, 15, 14, 0),
    color: Colors.red,
    shape: BoxShape.rectangle,
  );

  static final testEvent3 = Event(
    id: 'event-3',
    name: 'Future Event',
    time: DateTime.utc(2024, 7, 20, 9, 0),
    color: Colors.green,
    shape: BoxShape.circle,
  );

  // Test calendars (events are now in subcollections, not embedded)
  static final testCalendar = Calendar(
    id: 'test-user-123_Test Calendar',
    owner: 'test-user-123',
    name: 'Test Calendar',
    sharedWith: {},
  );

  static final emptyCalendar = Calendar(
    id: 'test-user-123_Empty Calendar',
    owner: 'test-user-123',
    name: 'Empty Calendar',
    sharedWith: {},
  );

  static final sharedCalendar = Calendar(
    id: 'friend-user-456_Shared Calendar',
    owner: 'friend-user-456',
    name: 'Shared Calendar',
    sharedWith: {'test-user-123'},
  );

  // Event list for testing
  static final eventListForCalendar = [
    Event(
      id: 'event-a',
      name: 'Event A',
      time: DateTime.utc(2024, 5, 10, 8, 0),
      color: Colors.blue,
    ),
    Event(
      id: 'event-b',
      name: 'Event B',
      time: DateTime.utc(2024, 5, 10, 12, 0),
      color: Colors.red,
    ),
    Event(
      id: 'event-c',
      name: 'Event C',
      time: DateTime.utc(2024, 5, 11, 9, 0),
      color: Colors.green,
    ),
  ];

  // JSON representations for serialization tests
  static Map<String, dynamic> get testEventJson => {
        'id': 'event-1',
        'name': 'Test Event',
        'time': '2024-06-15T10:00:00.000Z',
        'attendees': null,
        'color': Colors.blue.toARGB32(),
        'shape': 'circle',
        'recurrence': 'none',
        'recurrenceEndDate': null,
      };

  static Map<String, dynamic> get testUserJson => {
        'uid': 'test-user-123',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'photoUrl': null,
        'isAdmin': false,
        'dateJoined': DateTime(2024, 1, 15).toUtc(),
        'friends': ['friend-user-456'],
      };
}
