// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'package:timeshare/data/services/auth_service.dart';
import 'package:timeshare/data/services/api_client.dart';

/// Mock implementation of [AuthService] for testing.
class MockAuthService implements AuthService {
  final _authStateController = StreamController<AuthState>.broadcast();

  String? _userId;
  String? _apiKey;
  AuthState _currentState = AuthState.unauthenticated;

  /// Get current auth state for testing
  AuthState get currentState => _currentState;

  /// Set the mock user (simulates logged in state)
  void setMockUser({required String userId, required String apiKey}) {
    _userId = userId;
    _apiKey = apiKey;
    _currentState = AuthState.authenticated;
    _authStateController.add(AuthState.authenticated);
  }

  /// Clear the mock user (simulates logged out state)
  void clearMockUser() {
    _userId = null;
    _apiKey = null;
    _currentState = AuthState.unauthenticated;
    _authStateController.add(AuthState.unauthenticated);
  }

  @override
  String? get apiKey => _apiKey;

  @override
  String? get currentUserId => _userId;

  @override
  Stream<AuthState> get authStateStream => _authStateController.stream;

  @override
  Future<String> login(String email, String password) async {
    _userId = 'mock-user-id';
    _apiKey = 'mock-api-key';
    _currentState = AuthState.authenticated;
    _authStateController.add(AuthState.authenticated);
    return _userId!;
  }

  @override
  Future<String> signup(String email, String password, String displayName) async {
    _userId = 'mock-user-id';
    _apiKey = 'mock-api-key';
    _currentState = AuthState.authenticated;
    _authStateController.add(AuthState.authenticated);
    return _userId!;
  }

  @override
  Future<void> logout() async {
    _userId = null;
    _apiKey = null;
    _currentState = AuthState.unauthenticated;
    _authStateController.add(AuthState.unauthenticated);
  }

  @override
  Future<bool> loadStoredCredentials() async {
    if (_userId != null && _apiKey != null) {
      _authStateController.add(AuthState.authenticated);
      return true;
    }
    _authStateController.add(AuthState.unauthenticated);
    return false;
  }

  void dispose() {
    _authStateController.close();
  }
}

/// Mock implementation of [ApiClient] for testing.
class MockApiClient implements ApiClient {
  final Map<String, ApiResponse> _getResponses = {};
  final Map<String, ApiResponse> _postResponses = {};
  final Map<String, ApiResponse> _putResponses = {};
  final Map<String, ApiResponse> _patchResponses = {};
  final Map<String, ApiResponse> _deleteResponses = {};

  final List<String> getRequests = [];
  final List<String> postRequests = [];
  final List<String> putRequests = [];
  final List<String> patchRequests = [];
  final List<String> deleteRequests = [];

  /// Set the response for a GET request path
  void setGetResponse(String path, ApiResponse response) {
    _getResponses[path] = response;
  }

  /// Set the response for a POST request path
  void setPostResponse(String path, ApiResponse response) {
    _postResponses[path] = response;
  }

  /// Set the response for a PUT request path
  void setPutResponse(String path, ApiResponse response) {
    _putResponses[path] = response;
  }

  /// Set the response for a PATCH request path
  void setPatchResponse(String path, ApiResponse response) {
    _patchResponses[path] = response;
  }

  /// Set the response for a DELETE request path
  void setDeleteResponse(String path, ApiResponse response) {
    _deleteResponses[path] = response;
  }

  @override
  Future<ApiResponse> get(String path) async {
    getRequests.add(path);
    final response = _getResponses[path];
    if (response == null) {
      throw ApiException(
        statusCode: 404,
        message: 'Not found',
      );
    }
    return response;
  }

  @override
  Future<ApiResponse> post(String path, {String? body}) async {
    postRequests.add(path);
    final response = _postResponses[path];
    if (response == null) {
      throw ApiException(
        statusCode: 404,
        message: 'Not found',
      );
    }
    return response;
  }

  @override
  Future<ApiResponse> put(String path, {String? body}) async {
    putRequests.add(path);
    final response = _putResponses[path];
    if (response == null) {
      throw ApiException(
        statusCode: 404,
        message: 'Not found',
      );
    }
    return response;
  }

  @override
  Future<ApiResponse> patch(String path, {String? body}) async {
    patchRequests.add(path);
    final response = _patchResponses[path];
    if (response == null) {
      throw ApiException(
        statusCode: 404,
        message: 'Not found',
      );
    }
    return response;
  }

  @override
  Future<ApiResponse> delete(String path) async {
    deleteRequests.add(path);
    final response = _deleteResponses[path];
    if (response == null) {
      // Delete requests often don't have a body
      return ApiResponse(statusCode: 204, body: '', headers: {});
    }
    return response;
  }

  void clear() {
    _getResponses.clear();
    _postResponses.clear();
    _putResponses.clear();
    _patchResponses.clear();
    _deleteResponses.clear();
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
