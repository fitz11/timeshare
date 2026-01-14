// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/repo/rest_api_repo.dart';
import 'package:timeshare/data/repo/rest_api_user_repo.dart';
import 'package:timeshare/data/repo/logged_calendar_repo.dart';
import 'package:timeshare/data/repo/logged_user_repo.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/providers/user/user_providers.dart';
import 'package:timeshare/services/logging/app_logger.dart';

import '../fixtures/mock_rest_services.dart';
import '../fixtures/test_data.dart';

/// Creates a ProviderContainer with mocked REST API services.
/// Useful for unit testing providers.
ProviderContainer createTestContainer({
  bool signedIn = true,
  bool seedData = true,
}) {
  final mockAuth = MockAuthService();
  final mockApiClient = MockApiClient();

  if (signedIn) {
    mockAuth.setMockUser(
      userId: TestData.testUserId,
      apiKey: 'test-api-key',
    );
  }

  if (seedData) {
    _seedMockApiClient(mockApiClient);
  } else {
    _seedEmptyResponses(mockApiClient);
  }

  final calendarRepo = RestApiRepository(client: mockApiClient);
  final userRepo = RestApiUserRepository(
    client: mockApiClient,
    authService: mockAuth,
    calendarRepo: calendarRepo,
  );

  return ProviderContainer(
    overrides: [
      authServiceProvider.overrideWithValue(mockAuth),
      calendarRepositoryProvider.overrideWithValue(
        LoggedCalendarRepository(calendarRepo, AppLogger()),
      ),
      userRepositoryProvider.overrideWithValue(
        LoggedUserRepository(userRepo, AppLogger()),
      ),
    ],
  );
}

/// Creates a ProviderContainer with specific mock instances.
ProviderContainer createTestContainerWithMocks({
  required MockAuthService mockAuth,
  required MockApiClient mockApiClient,
}) {
  final calendarRepo = RestApiRepository(client: mockApiClient);
  final userRepo = RestApiUserRepository(
    client: mockApiClient,
    authService: mockAuth,
    calendarRepo: calendarRepo,
  );

  return ProviderContainer(
    overrides: [
      authServiceProvider.overrideWithValue(mockAuth),
      calendarRepositoryProvider.overrideWithValue(
        LoggedCalendarRepository(calendarRepo, AppLogger()),
      ),
      userRepositoryProvider.overrideWithValue(
        LoggedUserRepository(userRepo, AppLogger()),
      ),
    ],
  );
}

/// Creates a ProviderScope widget wrapper for widget tests.
ProviderScope createTestProviderScope({
  required Widget child,
  bool signedIn = true,
  bool seedData = true,
}) {
  final mockAuth = MockAuthService();
  final mockApiClient = MockApiClient();

  if (signedIn) {
    mockAuth.setMockUser(
      userId: TestData.testUserId,
      apiKey: 'test-api-key',
    );
  }

  if (seedData) {
    _seedMockApiClient(mockApiClient);
  } else {
    _seedEmptyResponses(mockApiClient);
  }

  final calendarRepo = RestApiRepository(client: mockApiClient);
  final userRepo = RestApiUserRepository(
    client: mockApiClient,
    authService: mockAuth,
    calendarRepo: calendarRepo,
  );

  return ProviderScope(
    overrides: [
      authServiceProvider.overrideWithValue(mockAuth),
      calendarRepositoryProvider.overrideWithValue(
        LoggedCalendarRepository(calendarRepo, AppLogger()),
      ),
      userRepositoryProvider.overrideWithValue(
        LoggedUserRepository(userRepo, AppLogger()),
      ),
    ],
    child: child,
  );
}

/// Creates a ProviderScope with specific mock instances for widget tests.
ProviderScope createTestProviderScopeWithMocks({
  required Widget child,
  required MockAuthService mockAuth,
  required MockApiClient mockApiClient,
}) {
  final calendarRepo = RestApiRepository(client: mockApiClient);
  final userRepo = RestApiUserRepository(
    client: mockApiClient,
    authService: mockAuth,
    calendarRepo: calendarRepo,
  );

  return ProviderScope(
    overrides: [
      authServiceProvider.overrideWithValue(mockAuth),
      calendarRepositoryProvider.overrideWithValue(
        LoggedCalendarRepository(calendarRepo, AppLogger()),
      ),
      userRepositoryProvider.overrideWithValue(
        LoggedUserRepository(userRepo, AppLogger()),
      ),
    ],
    child: child,
  );
}

/// Seed the mock API client with test data
void _seedMockApiClient(MockApiClient client, {bool withFriends = true}) {
  // Calendars endpoint
  client.setGetResponse(
    '/api/v1/timeshare/calendars/',
    mockResponse(jsonEncode([
      {
        'id': TestData.testCalendarId,
        'owner': TestData.testUserId,
        'name': 'Test Calendar',
        'sharedWith': <String>[],
      },
    ])),
  );

  // Calendar events endpoint
  client.setGetResponse(
    '/api/v1/timeshare/calendars/${TestData.testCalendarId}/events/',
    mockResponse(jsonEncode([
      {
        'id': TestData.testEventId,
        'name': 'Test Event',
        'time': DateTime.now().toIso8601String(),
        'attendees': <String>[],
        'color': 0xFF2196F3,
        'shape': 'circle',
        'recurrence': 'none',
      },
    ])),
  );

  // User endpoint
  client.setGetResponse(
    '/api/v1/timeshare/users/${TestData.testUserId}/',
    mockResponse(jsonEncode({
      'uid': TestData.testUserId,
      'email': 'test@example.com',
      'displayName': 'Test User',
      'friends': withFriends ? ['friend-user-456'] : <String>[],
      'dateJoined': DateTime(2024, 1, 15).toUtc().toIso8601String(),
      'photoUrl': null,
      'isAdmin': false,
    })),
  );

  // Friends endpoint - return friend data when withFriends is true
  client.setGetResponse(
    '/api/v1/timeshare/users/${TestData.testUserId}/friends/',
    mockResponse(jsonEncode(withFriends
        ? [
            {
              'uid': 'friend-user-456',
              'email': 'friend@example.com',
              'displayName': 'Friend User',
              'friends': [TestData.testUserId],
              'dateJoined': DateTime(2024, 2, 20).toUtc().toIso8601String(),
              'photoUrl': null,
              'isAdmin': false,
            },
          ]
        : <Map<String, dynamic>>[])),
  );

  // User search endpoint
  client.setGetResponse(
    '/api/v1/timeshare/users/search/?email=test',
    mockResponse(jsonEncode(<Map<String, dynamic>>[])),
  );

  // User search endpoint for 'friend@' query (used in tests)
  client.setGetResponse(
    '/api/v1/timeshare/users/search/?email=friend%40',
    mockResponse(jsonEncode([
      {
        'uid': 'friend-user-456',
        'email': 'friend@example.com',
        'displayName': 'Friend User',
        'friends': [TestData.testUserId],
        'dateJoined': DateTime(2024, 2, 20).toUtc().toIso8601String(),
        'photoUrl': null,
        'isAdmin': false,
      },
    ])),
  );

  // POST/PUT/DELETE endpoints for mutation tests
  _seedMutationEndpoints(client);
}

/// Seed mutation endpoints (POST/PUT/DELETE) for integration tests
void _seedMutationEndpoints(MockApiClient client) {
  // Create calendar
  client.setPostResponse(
    '/api/v1/timeshare/calendars/',
    mockResponse(jsonEncode({
      'id': 'new-calendar-id',
      'owner': TestData.testUserId,
      'name': 'New Calendar',
      'sharedWith': <String>[],
    }), statusCode: 201),
  );

  // Share calendar
  client.setPostResponse(
    '/api/v1/timeshare/calendars/${TestData.testCalendarId}/share/',
    mockResponse('', statusCode: 200),
  );

  // Unshare calendar
  client.setPostResponse(
    '/api/v1/timeshare/calendars/${TestData.testCalendarId}/unshare/',
    mockResponse('', statusCode: 200),
  );

  // Delete calendar
  client.setDeleteResponse(
    '/api/v1/timeshare/calendars/${TestData.testCalendarId}/',
    mockResponse('', statusCode: 204),
  );

  // Add event to calendar
  client.setPostResponse(
    '/api/v1/timeshare/calendars/${TestData.testCalendarId}/events/',
    mockResponse(jsonEncode({
      'id': 'new-event-id',
      'name': 'New Event',
      'time': DateTime.now().toIso8601String(),
      'attendees': <String>[],
      'color': 0xFF2196F3,
      'shape': 'circle',
      'recurrence': 'none',
    }), statusCode: 201),
  );

  // Update event
  client.setPutResponse(
    '/api/v1/timeshare/calendars/${TestData.testCalendarId}/events/${TestData.testEventId}/',
    mockResponse(jsonEncode({
      'id': TestData.testEventId,
      'name': 'Updated Event',
      'time': DateTime.now().toIso8601String(),
      'attendees': <String>[],
      'color': 0xFFE91E63,
      'shape': 'circle',
      'recurrence': 'none',
    })),
  );

  // Delete event
  client.setDeleteResponse(
    '/api/v1/timeshare/calendars/${TestData.testCalendarId}/events/${TestData.testEventId}/',
    mockResponse('', statusCode: 204),
  );
}

/// Seed empty responses (for testing empty states without 404 errors)
void _seedEmptyResponses(MockApiClient client) {
  client.setGetResponse(
    '/api/v1/timeshare/calendars/',
    mockResponse(jsonEncode(<Map<String, dynamic>>[])),
  );

  client.setGetResponse(
    '/api/v1/timeshare/users/${TestData.testUserId}/',
    mockResponse(jsonEncode({
      'uid': TestData.testUserId,
      'email': 'test@example.com',
      'displayName': 'Test User',
      'friends': <String>[],
      'dateJoined': DateTime(2024, 1, 15).toUtc().toIso8601String(),
      'photoUrl': null,
      'isAdmin': false,
    })),
  );

  client.setGetResponse(
    '/api/v1/timeshare/users/${TestData.testUserId}/friends/',
    mockResponse(jsonEncode(<Map<String, dynamic>>[])),
  );

  client.setGetResponse(
    '/api/v1/timeshare/users/search/?email=test',
    mockResponse(jsonEncode(<Map<String, dynamic>>[])),
  );

  // Add mutation endpoints for empty state tests too
  _seedMutationEndpoints(client);
}
