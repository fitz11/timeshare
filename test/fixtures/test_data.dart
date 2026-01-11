// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/models/user/app_user.dart';

/// Test data fixtures for unit and widget tests.
class TestData {
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
    name: 'Test Event',
    time: DateTime.utc(2024, 6, 15, 10, 0),
    calendarId: 'test-user-123_Test Calendar',
    color: Colors.blue,
    shape: BoxShape.circle,
  );

  static final testEvent2 = Event(
    name: 'Second Event',
    time: DateTime.utc(2024, 6, 15, 14, 0),
    calendarId: 'test-user-123_Test Calendar',
    color: Colors.red,
    shape: BoxShape.rectangle,
  );

  static final testEvent3 = Event(
    name: 'Future Event',
    time: DateTime.utc(2024, 7, 20, 9, 0),
    calendarId: 'test-user-123_Test Calendar',
    color: Colors.green,
    shape: BoxShape.circle,
  );

  // Test calendars
  static final testCalendar = Calendar(
    id: 'test-user-123_Test Calendar',
    owner: 'test-user-123',
    name: 'Test Calendar',
    sharedWith: {},
    events: {
      DateTime.utc(2024, 6, 15): [testEvent, testEvent2],
      DateTime.utc(2024, 7, 20): [testEvent3],
    },
  );

  static final emptyCalendar = Calendar(
    id: 'test-user-123_Empty Calendar',
    owner: 'test-user-123',
    name: 'Empty Calendar',
    sharedWith: {},
    events: {},
  );

  static final sharedCalendar = Calendar(
    id: 'friend-user-456_Shared Calendar',
    owner: 'friend-user-456',
    name: 'Shared Calendar',
    sharedWith: {'test-user-123'},
    events: {},
  );

  // Event list for testing Calendar.fromEventList()
  static final eventListForCalendar = [
    Event(
      name: 'Event A',
      time: DateTime.utc(2024, 5, 10, 8, 0),
      calendarId: 'cal1',
      color: Colors.blue,
    ),
    Event(
      name: 'Event B',
      time: DateTime.utc(2024, 5, 10, 12, 0),
      calendarId: 'cal1',
      color: Colors.red,
    ),
    Event(
      name: 'Event C',
      time: DateTime.utc(2024, 5, 11, 9, 0),
      calendarId: 'cal1',
      color: Colors.green,
    ),
  ];

  // JSON representations for serialization tests
  static Map<String, dynamic> get testEventJson => {
        'name': 'Test Event',
        'time': '2024-06-15T10:00:00.000Z',
        'calendarId': 'test-user-123_Test Calendar',
        'atendees': null,
        'color': Colors.blue.toARGB32(),
        'shape': 'circle',
      };

  static Map<String, dynamic> get testUserJson => {
        'uid': 'test-user-123',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'photoUrl': null,
        'isAdmin': false,
        'joinedAt': DateTime(2024, 1, 15).toUtc(),
        'friends': ['friend-user-456'],
      };
}
