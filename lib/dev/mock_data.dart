// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/models/user/app_user.dart';
import 'mock_services.dart';

/// Sample data for mock development environment.
class MockData {
  static const mockUserId = 'mock-user-123';
  static const mockApiKey = 'mock-api-key-dev';

  static const calendarId1 = 'mock-user-123_My Calendar';
  static const calendarId2 = 'mock-user-123_Work';
  static const sharedCalendarId = 'friend-456_Shared with me';

  static final mockUser = AppUser(
    uid: mockUserId,
    email: 'dev@example.com',
    displayName: 'Dev User',
    joinedAt: DateTime(2024, 1, 1),
    friends: ['friend-456'],
  );

  static final friendUser = AppUser(
    uid: 'friend-456',
    email: 'friend@example.com',
    displayName: 'Friend User',
    joinedAt: DateTime(2024, 2, 1),
    friends: [mockUserId],
  );

  static final myCalendar = Calendar(
    id: calendarId1,
    owner: mockUserId,
    name: 'My Calendar',
    sharedWith: {},
  );

  static final workCalendar = Calendar(
    id: calendarId2,
    owner: mockUserId,
    name: 'Work',
    sharedWith: {'friend-456'},
  );

  static final sharedCalendar = Calendar(
    id: sharedCalendarId,
    owner: 'friend-456',
    name: 'Shared with me',
    sharedWith: {mockUserId},
  );

  /// Generate sample events around today's date
  static List<Event> generateSampleEvents() {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);

    return [
      Event(
        id: 'event-1',
        name: 'Team Meeting',
        time: today.add(const Duration(hours: 10)),
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      Event(
        id: 'event-2',
        name: 'Lunch with Alex',
        time: today.add(const Duration(hours: 12, minutes: 30)),
        color: Colors.green,
        shape: BoxShape.rectangle,
      ),
      Event(
        id: 'event-3',
        name: 'Project Review',
        time: today.add(const Duration(days: 1, hours: 14)),
        color: Colors.orange,
        shape: BoxShape.circle,
      ),
      Event(
        id: 'event-4',
        name: 'Doctor Appointment',
        time: today.add(const Duration(days: 2, hours: 9)),
        color: Colors.red,
        shape: BoxShape.rectangle,
      ),
      Event(
        id: 'event-5',
        name: 'Coffee Chat',
        time: today.add(const Duration(days: 3, hours: 15)),
        color: Colors.purple,
        shape: BoxShape.circle,
      ),
      Event(
        id: 'event-6',
        name: 'Birthday Party',
        time: today.add(const Duration(days: 7, hours: 18)),
        color: Colors.pink,
        shape: BoxShape.circle,
      ),
    ];
  }

  static List<Event> generateWorkEvents() {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);

    return [
      Event(
        id: 'work-event-1',
        name: 'Sprint Planning',
        time: today.add(const Duration(days: 1, hours: 10)),
        color: Colors.indigo,
        shape: BoxShape.rectangle,
      ),
      Event(
        id: 'work-event-2',
        name: 'Code Review',
        time: today.add(const Duration(days: 2, hours: 11)),
        color: Colors.teal,
        shape: BoxShape.circle,
      ),
    ];
  }

  static List<Event> generateSharedEvents() {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);

    return [
      Event(
        id: 'shared-event-1',
        name: 'Game Night',
        time: today.add(const Duration(days: 5, hours: 19)),
        color: Colors.amber,
        shape: BoxShape.circle,
      ),
    ];
  }
}

/// Seed the mock API client with sample data for development
void seedMockApiClient(MockApiClient client) {
  final events = MockData.generateSampleEvents();
  final workEvents = MockData.generateWorkEvents();
  final sharedEvents = MockData.generateSharedEvents();

  // Seed calendars (stateful - supports CRUD)
  client.seedCalendar({
    'id': MockData.calendarId1,
    'owner': MockData.mockUserId,
    'name': 'My Calendar',
    'sharedWith': <String>[],
    'version': 1,
  });
  client.seedCalendar({
    'id': MockData.calendarId2,
    'owner': MockData.mockUserId,
    'name': 'Work',
    'sharedWith': ['friend-456'],
    'version': 1,
  });
  client.seedCalendar({
    'id': MockData.sharedCalendarId,
    'owner': 'friend-456',
    'name': 'Shared with me',
    'sharedWith': [MockData.mockUserId],
    'version': 1,
  });

  // Seed events (stateful - supports CRUD)
  for (final event in events) {
    client.seedEvent(MockData.calendarId1, _eventToJson(event));
  }
  for (final event in workEvents) {
    client.seedEvent(MockData.calendarId2, _eventToJson(event));
  }
  for (final event in sharedEvents) {
    client.seedEvent(MockData.sharedCalendarId, _eventToJson(event));
  }

  // Seed users (stateful)
  client.seedUser(_userToJson(MockData.mockUser));
  client.seedUser(_userToJson(MockData.friendUser));

  // Friend requests (empty) - static responses for polling endpoints
  client.setGetResponse(
    '/api/v1/timeshare/friend-requests/incoming/',
    mockResponse(jsonEncode(<Map<String, dynamic>>[])),
  );
  client.setGetResponse(
    '/api/v1/timeshare/friend-requests/sent/',
    mockResponse(jsonEncode(<Map<String, dynamic>>[])),
  );

  // Ownership transfers (empty) - static responses for polling endpoints
  client.setGetResponse(
    '/api/v1/timeshare/ownership-transfers/incoming/',
    mockResponse(jsonEncode(<Map<String, dynamic>>[])),
  );
  client.setGetResponse(
    '/api/v1/timeshare/ownership-transfers/sent/',
    mockResponse(jsonEncode(<Map<String, dynamic>>[])),
  );

  // User search endpoints - static response
  client.setGetResponse(
    '/api/v1/timeshare/users/search/?email=friend',
    mockResponse(jsonEncode([_userToJson(MockData.friendUser)])),
  );

  // Seed mutation endpoints for operations not yet handled statefully
  _seedMutationEndpoints(client);
}

void _seedMutationEndpoints(MockApiClient client) {
  // Share/unshare calendar - static responses
  client.setPostResponse(
    '/api/v1/timeshare/calendars/${MockData.calendarId1}/share/',
    mockResponse('', statusCode: 200),
  );
  client.setPostResponse(
    '/api/v1/timeshare/calendars/${MockData.calendarId1}/unshare/',
    mockResponse('', statusCode: 200),
  );
  client.setPostResponse(
    '/api/v1/timeshare/calendars/${MockData.calendarId2}/share/',
    mockResponse('', statusCode: 200),
  );
  client.setPostResponse(
    '/api/v1/timeshare/calendars/${MockData.calendarId2}/unshare/',
    mockResponse('', statusCode: 200),
  );

  // Friend request endpoints - static response
  client.setPostResponse(
    '/api/v1/timeshare/friend-requests/',
    mockResponse(jsonEncode({
      'id': 'new-friend-request-id',
      'senderId': MockData.mockUserId,
      'receiverId': 'other-user',
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
      'expiresAt': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
    }), statusCode: 201),
  );

  // Remove friend - static response
  client.setDeleteResponse(
    '/api/v1/timeshare/users/${MockData.mockUserId}/friends/friend-456/',
    mockResponse('', statusCode: 204),
  );
}

Map<String, dynamic> _eventToJson(Event event) {
  return {
    'id': event.id,
    'name': event.name,
    'time': event.time.toIso8601String(),
    'atendees': event.atendees,
    'color': event.color.toARGB32(),
    'shape': event.shape == BoxShape.circle ? 'circle' : 'rectangle',
    'recurrence': event.recurrence.name,
    'recurrenceEndDate': event.recurrenceEndDate?.toIso8601String(),
    'version': event.version,
  };
}

Map<String, dynamic> _userToJson(AppUser user) {
  return {
    'uid': user.uid,
    'email': user.email,
    'displayName': user.displayName,
    'photoUrl': user.photoUrl,
    'isAdmin': user.isAdmin,
    'dateJoined': user.joinedAt.toUtc().toIso8601String(),
    'friends': user.friends,
  };
}
