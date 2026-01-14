// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:convert';
import 'package:timeshare/data/services/auth_service.dart';
import 'package:timeshare/data/services/api_client.dart';

/// Mock implementation of [AuthService] for development/testing.
class MockAuthService implements AuthService {
  final _authStateController = StreamController<AuthState>.broadcast();

  String? _userId;
  String? _apiKey;
  String? _pendingVerificationEmail;
  AuthState _currentState = AuthState.unauthenticated;

  MockAuthService() {
    print('[MockAuthService] Constructor called');
  }

  /// Get current auth state
  AuthState get currentState {
    print('[MockAuthService] currentState getter called, returning: $_currentState');
    return _currentState;
  }

  /// Set the mock user (simulates logged in state)
  void setMockUser({required String userId, required String apiKey}) {
    print('[MockAuthService] setMockUser() called - userId: $userId');
    _userId = userId;
    _apiKey = apiKey;
    _currentState = AuthState.authenticated;
    print('[MockAuthService] Emitting AuthState.authenticated to stream...');
    _authStateController.add(AuthState.authenticated);
    print('[MockAuthService] setMockUser() complete');
  }

  /// Clear the mock user (simulates logged out state)
  void clearMockUser() {
    print('[MockAuthService] clearMockUser() called');
    _userId = null;
    _apiKey = null;
    _currentState = AuthState.unauthenticated;
    _authStateController.add(AuthState.unauthenticated);
    print('[MockAuthService] clearMockUser() complete');
  }

  @override
  String? get apiKey {
    print('[MockAuthService] apiKey getter called, returning: ${_apiKey != null ? "[REDACTED]" : "null"}');
    return _apiKey;
  }

  @override
  String? get currentUserId {
    print('[MockAuthService] currentUserId getter called, returning: $_userId');
    return _userId;
  }

  @override
  Stream<AuthState> get authStateStream {
    print('[MockAuthService] authStateStream getter called - returning stream');
    return _authStateController.stream;
  }

  @override
  Future<String> login(String email, String password) async {
    print('[MockAuthService] login() called - email: $email');
    _userId = 'mock-user-id';
    _apiKey = 'mock-api-key';
    _currentState = AuthState.authenticated;
    _authStateController.add(AuthState.authenticated);
    print('[MockAuthService] login() complete');
    return _userId!;
  }

  @override
  Future<String> signup(String email, String password, String displayName) async {
    print('[MockAuthService] signup() called - email: $email, displayName: $displayName');
    _userId = 'mock-user-id';
    _apiKey = 'mock-api-key';
    _currentState = AuthState.authenticated;
    _authStateController.add(AuthState.authenticated);
    print('[MockAuthService] signup() complete');
    return _userId!;
  }

  @override
  Future<void> logout() async {
    print('[MockAuthService] logout() called');
    _userId = null;
    _apiKey = null;
    _currentState = AuthState.unauthenticated;
    _authStateController.add(AuthState.unauthenticated);
    print('[MockAuthService] logout() complete');
  }

  @override
  Future<bool> loadStoredCredentials() async {
    print('[MockAuthService] loadStoredCredentials() START');
    print('[MockAuthService] - _userId: $_userId');
    print('[MockAuthService] - _apiKey: ${_apiKey != null ? "[SET]" : "null"}');
    if (_userId != null && _apiKey != null) {
      print('[MockAuthService] Credentials found, emitting AuthState.authenticated...');
      _authStateController.add(AuthState.authenticated);
      print('[MockAuthService] loadStoredCredentials() END - returning true');
      return true;
    }
    print('[MockAuthService] No credentials, emitting AuthState.unauthenticated...');
    _authStateController.add(AuthState.unauthenticated);
    print('[MockAuthService] loadStoredCredentials() END - returning false');
    return false;
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {}

  @override
  Future<void> changeEmail(String newEmail, String password) async {}

  @override
  Future<void> requestPasswordReset(String email) async {}

  @override
  String? get pendingVerificationEmail => _pendingVerificationEmail;

  @override
  Future<String> verifyEmail(String token) async {
    _userId = 'mock-user-id';
    _apiKey = 'mock-api-key';
    _pendingVerificationEmail = null;
    _currentState = AuthState.authenticated;
    _authStateController.add(AuthState.authenticated);
    return _userId!;
  }

  @override
  Future<void> resendVerificationEmail(String email) async {}

  @override
  void cancelPendingVerification() {
    _pendingVerificationEmail = null;
    _currentState = AuthState.unauthenticated;
    _authStateController.add(AuthState.unauthenticated);
  }

  void dispose() {
    _authStateController.close();
  }
}

/// Stateful mock implementation of [ApiClient] for development/testing.
///
/// Unlike a simple mock that returns pre-configured responses, this client
/// stores data in memory and properly handles CRUD operations.
class MockApiClient implements ApiClient {
  // In-memory data stores
  final Map<String, Map<String, dynamic>> _calendars = {};
  final Map<String, List<Map<String, dynamic>>> _events = {}; // calendarId -> events
  final Map<String, Map<String, dynamic>> _users = {};
  final List<Map<String, dynamic>> _friendRequests = [];
  final List<Map<String, dynamic>> _ownershipTransfers = [];

  // Static response overrides (for endpoints that don't need state)
  final Map<String, ApiResponse> _staticResponses = {};

  // Request tracking for debugging
  final List<String> getRequests = [];
  final List<String> postRequests = [];
  final List<String> putRequests = [];
  final List<String> patchRequests = [];
  final List<String> deleteRequests = [];

  int _nextEventId = 1000;

  MockApiClient() {
    print('[MockApiClient] Constructor called');
  }

  /// Seed initial calendar data
  void seedCalendar(Map<String, dynamic> calendar) {
    final id = calendar['id'] as String;
    _calendars[id] = calendar;
    _events[id] = [];
    print('[MockApiClient] Seeded calendar: $id');
  }

  /// Seed initial event data for a calendar
  void seedEvent(String calendarId, Map<String, dynamic> event) {
    _events[calendarId] ??= [];
    _events[calendarId]!.add(event);
    print('[MockApiClient] Seeded event ${event['id']} for calendar: $calendarId');
  }

  /// Seed user data
  void seedUser(Map<String, dynamic> user) {
    final uid = user['uid'] as String;
    _users[uid] = user;
    print('[MockApiClient] Seeded user: $uid');
  }

  /// Set a static response for a specific path (for endpoints that don't need state)
  void setStaticResponse(String method, String path, ApiResponse response) {
    _staticResponses['$method:$path'] = response;
    print('[MockApiClient] Set static response for $method $path');
  }

  // Legacy methods for compatibility
  void setGetResponse(String path, ApiResponse response) =>
      setStaticResponse('GET', path, response);
  void setPostResponse(String path, ApiResponse response) =>
      setStaticResponse('POST', path, response);
  void setPutResponse(String path, ApiResponse response) =>
      setStaticResponse('PUT', path, response);
  void setPatchResponse(String path, ApiResponse response) =>
      setStaticResponse('PATCH', path, response);
  void setDeleteResponse(String path, ApiResponse response) =>
      setStaticResponse('DELETE', path, response);

  @override
  Future<ApiResponse> get(String path) async {
    print('[MockApiClient] GET $path - START');
    getRequests.add(path);

    // Check for static response first
    final staticKey = 'GET:$path';
    if (_staticResponses.containsKey(staticKey)) {
      print('[MockApiClient] GET $path - STATIC RESPONSE');
      return _staticResponses[staticKey]!;
    }

    // Handle calendar list
    if (path == '/api/v1/timeshare/calendars/') {
      final calendars = _calendars.values.toList();
      print('[MockApiClient] GET $path - returning ${calendars.length} calendars');
      return _jsonResponse(calendars);
    }

    // Handle single calendar: /api/v1/timeshare/calendars/{id}/
    final calendarMatch = RegExp(r'^/api/v1/timeshare/calendars/([^/]+)/$').firstMatch(path);
    if (calendarMatch != null) {
      final calendarId = Uri.decodeComponent(calendarMatch.group(1)!);
      final calendar = _calendars[calendarId];
      if (calendar != null) {
        print('[MockApiClient] GET $path - found calendar');
        return _jsonResponse(calendar);
      }
      print('[MockApiClient] GET $path - calendar not found');
      throw ApiException(statusCode: 404, message: 'Calendar not found');
    }

    // Handle events for a calendar: /api/v1/timeshare/calendars/{id}/events/
    final eventsMatch = RegExp(r'^/api/v1/timeshare/calendars/([^/]+)/events/$').firstMatch(path);
    if (eventsMatch != null) {
      final calendarId = Uri.decodeComponent(eventsMatch.group(1)!);
      final events = _events[calendarId] ?? [];
      print('[MockApiClient] GET $path - returning ${events.length} events');
      return _jsonResponse(events);
    }

    // Handle user profile
    final userMatch = RegExp(r'^/api/v1/timeshare/users/([^/]+)/$').firstMatch(path);
    if (userMatch != null) {
      final uid = Uri.decodeComponent(userMatch.group(1)!);
      final user = _users[uid];
      if (user != null) {
        print('[MockApiClient] GET $path - found user');
        return _jsonResponse(user);
      }
    }

    // Handle friends list
    final friendsMatch = RegExp(r'^/api/v1/timeshare/users/([^/]+)/friends/$').firstMatch(path);
    if (friendsMatch != null) {
      final uid = Uri.decodeComponent(friendsMatch.group(1)!);
      final user = _users[uid];
      if (user != null) {
        final friendIds = (user['friends'] as List?) ?? [];
        final friends = friendIds
            .map((id) => _users[id])
            .where((u) => u != null)
            .toList();
        print('[MockApiClient] GET $path - returning ${friends.length} friends');
        return _jsonResponse(friends);
      }
    }

    // Handle user search: /api/v1/timeshare/users/search/?email=query
    final searchMatch = RegExp(r'^/api/v1/timeshare/users/search/\?email=(.+)$').firstMatch(path);
    if (searchMatch != null) {
      final query = Uri.decodeComponent(searchMatch.group(1)!).toLowerCase();
      // Search users by email (case-insensitive partial match)
      final results = _users.values
          .where((u) => (u['email'] as String?)?.toLowerCase().contains(query) ?? false)
          .toList();
      print('[MockApiClient] GET $path - found ${results.length} users matching "$query"');
      return _jsonResponse(results);
    }

    print('[MockApiClient] GET $path - NOT FOUND (404)');
    throw ApiException(statusCode: 404, message: 'Not found: $path');
  }

  @override
  Future<ApiResponse> post(String path, {String? body}) async {
    print('[MockApiClient] POST $path - START');
    if (body != null) print('[MockApiClient] POST body: $body');
    postRequests.add(path);

    // Check for static response first
    final staticKey = 'POST:$path';
    if (_staticResponses.containsKey(staticKey)) {
      print('[MockApiClient] POST $path - STATIC RESPONSE');
      return _staticResponses[staticKey]!;
    }

    // Handle create calendar
    if (path == '/api/v1/timeshare/calendars/') {
      final data = body != null ? jsonDecode(body) as Map<String, dynamic> : {};
      final name = data['name'] as String? ?? 'New Calendar';
      final owner = data['owner'] as String? ?? 'mock-user-123';
      final id = '${owner}_$name';

      final calendar = {
        'id': id,
        'owner': owner,
        'name': name,
        'sharedWith': <String>[],
        'version': 1,
      };
      _calendars[id] = calendar;
      _events[id] = [];
      print('[MockApiClient] POST $path - created calendar: $id');
      return _jsonResponse(calendar, statusCode: 201);
    }

    // Handle create event: /api/v1/timeshare/calendars/{id}/events/
    final eventsMatch = RegExp(r'^/api/v1/timeshare/calendars/([^/]+)/events/$').firstMatch(path);
    if (eventsMatch != null) {
      final calendarId = Uri.decodeComponent(eventsMatch.group(1)!);
      if (!_calendars.containsKey(calendarId)) {
        throw ApiException(statusCode: 404, message: 'Calendar not found');
      }

      final data = body != null ? jsonDecode(body) as Map<String, dynamic> : {};
      final eventId = data['id'] as String? ?? 'event-${_nextEventId++}';

      final event = {
        'id': eventId,
        'name': data['name'] ?? 'New Event',
        'time': data['time'] ?? DateTime.now().toIso8601String(),
        'atendees': data['atendees'],
        'color': data['color'],
        'shape': data['shape'] ?? 'circle',
        'recurrence': data['recurrence'] ?? 'none',
        'recurrenceEndDate': data['recurrenceEndDate'],
        'calendarId': calendarId,
        'version': 1,
      };

      _events[calendarId]!.add(event);
      print('[MockApiClient] POST $path - created event: $eventId');
      return _jsonResponse(event, statusCode: 201);
    }

    print('[MockApiClient] POST $path - NOT FOUND (404)');
    throw ApiException(statusCode: 404, message: 'Not found: $path');
  }

  @override
  Future<ApiResponse> put(String path, {String? body}) async {
    print('[MockApiClient] PUT $path - START');
    putRequests.add(path);

    // Check for static response first
    final staticKey = 'PUT:$path';
    if (_staticResponses.containsKey(staticKey)) {
      print('[MockApiClient] PUT $path - STATIC RESPONSE');
      return _staticResponses[staticKey]!;
    }

    // Handle update event: /api/v1/timeshare/calendars/{calId}/events/{eventId}/
    final eventMatch = RegExp(r'^/api/v1/timeshare/calendars/([^/]+)/events/([^/]+)/$').firstMatch(path);
    if (eventMatch != null) {
      final calendarId = Uri.decodeComponent(eventMatch.group(1)!);
      final eventId = Uri.decodeComponent(eventMatch.group(2)!);

      final events = _events[calendarId];
      if (events != null) {
        final index = events.indexWhere((e) => e['id'] == eventId);
        if (index != -1) {
          final data = body != null ? jsonDecode(body) as Map<String, dynamic> : <String, dynamic>{};
          final updatedEvent = <String, dynamic>{...events[index], ...data, 'version': (events[index]['version'] ?? 1) + 1};
          events[index] = updatedEvent;
          print('[MockApiClient] PUT $path - updated event');
          return _jsonResponse(updatedEvent);
        }
      }
      throw ApiException(statusCode: 404, message: 'Event not found');
    }

    print('[MockApiClient] PUT $path - NOT FOUND (404)');
    throw ApiException(statusCode: 404, message: 'Not found: $path');
  }

  @override
  Future<ApiResponse> patch(String path, {String? body}) async {
    print('[MockApiClient] PATCH $path - START');
    patchRequests.add(path);

    // Check for static response first
    final staticKey = 'PATCH:$path';
    if (_staticResponses.containsKey(staticKey)) {
      print('[MockApiClient] PATCH $path - STATIC RESPONSE');
      return _staticResponses[staticKey]!;
    }

    print('[MockApiClient] PATCH $path - NOT FOUND (404)');
    throw ApiException(statusCode: 404, message: 'Not found: $path');
  }

  @override
  Future<ApiResponse> delete(String path) async {
    print('[MockApiClient] DELETE $path - START');
    deleteRequests.add(path);

    // Check for static response first
    final staticKey = 'DELETE:$path';
    if (_staticResponses.containsKey(staticKey)) {
      print('[MockApiClient] DELETE $path - STATIC RESPONSE');
      return _staticResponses[staticKey]!;
    }

    // Handle delete calendar: /api/v1/timeshare/calendars/{id}/
    final calendarMatch = RegExp(r'^/api/v1/timeshare/calendars/([^/]+)/$').firstMatch(path);
    if (calendarMatch != null) {
      final calendarId = Uri.decodeComponent(calendarMatch.group(1)!);
      if (_calendars.remove(calendarId) != null) {
        _events.remove(calendarId);
        print('[MockApiClient] DELETE $path - deleted calendar');
        return ApiResponse(statusCode: 204, body: '', headers: {});
      }
      throw ApiException(statusCode: 404, message: 'Calendar not found');
    }

    // Handle delete event: /api/v1/timeshare/calendars/{calId}/events/{eventId}/
    final eventMatch = RegExp(r'^/api/v1/timeshare/calendars/([^/]+)/events/([^/]+)/$').firstMatch(path);
    if (eventMatch != null) {
      final calendarId = Uri.decodeComponent(eventMatch.group(1)!);
      final eventId = Uri.decodeComponent(eventMatch.group(2)!);

      final events = _events[calendarId];
      if (events != null) {
        events.removeWhere((e) => e['id'] == eventId);
        print('[MockApiClient] DELETE $path - deleted event');
        return ApiResponse(statusCode: 204, body: '', headers: {});
      }
    }

    // Default success for unknown delete paths
    print('[MockApiClient] DELETE $path - DEFAULT SUCCESS (204)');
    return ApiResponse(statusCode: 204, body: '', headers: {});
  }

  ApiResponse _jsonResponse(Object data, {int statusCode = 200}) {
    return ApiResponse(
      statusCode: statusCode,
      body: jsonEncode(data),
      headers: {'content-type': 'application/json'},
    );
  }

  void clear() {
    print('[MockApiClient] clear() called');
    _calendars.clear();
    _events.clear();
    _users.clear();
    _friendRequests.clear();
    _ownershipTransfers.clear();
    _staticResponses.clear();
    getRequests.clear();
    postRequests.clear();
    putRequests.clear();
    patchRequests.clear();
    deleteRequests.clear();
  }
}

/// Create a mock API response
ApiResponse mockResponse(String body, {int statusCode = 200}) {
  return ApiResponse(
    statusCode: statusCode,
    body: body,
    headers: {'content-type': 'application/json'},
  );
}
