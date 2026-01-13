// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:timeshare/data/services/auth_service.dart';

/// REST API implementation of [AuthService] using API key authentication.
///
/// Handles:
/// - Email/password login and signup
/// - API key storage and retrieval
/// - Auth state broadcasting
/// - Secure credential persistence
class RestApiAuthService implements AuthService {
  final String baseUrl;
  final HttpClient _httpClient;
  final SecureStorage _storage;

  String? _apiKey;
  String? _userId;
  final _authStateController = StreamController<AuthState>.broadcast();

  RestApiAuthService({
    required this.baseUrl,
    required SecureStorage storage,
    HttpClient? httpClient,
  })  : _storage = storage,
        _httpClient = httpClient ?? HttpClient();

  @override
  String? get apiKey => _apiKey;

  @override
  String? get currentUserId => _userId;

  @override
  Stream<AuthState> get authStateStream => _authStateController.stream;

  @override
  Future<String> login(String email, String password) async {
    _authStateController.add(AuthState.loading);

    try {
      final response = await _postJson('/api/v1/timeshare/auth/login/', {
        'email': email,
        'password': password,
      });

      final data = jsonDecode(response);
      _apiKey = data['api_key'] as String;
      final user = data['user'] as Map<String, dynamic>;
      _userId = user['uid'] as String;

      // Persist credentials
      await _storage.write(key: _apiKeyStorageKey, value: _apiKey!);
      await _storage.write(key: _userIdStorageKey, value: _userId!);

      _authStateController.add(AuthState.authenticated);
      return _userId!;
    } catch (e) {
      _authStateController.add(AuthState.error);
      rethrow;
    }
  }

  @override
  Future<String> signup(String email, String password, String displayName) async {
    _authStateController.add(AuthState.loading);

    try {
      final response = await _postJson('/api/v1/timeshare/auth/register/', {
        'email': email,
        'password': password,
        'display_name': displayName,
      });

      final data = jsonDecode(response);
      _apiKey = data['api_key'] as String;
      final user = data['user'] as Map<String, dynamic>;
      _userId = user['uid'] as String;

      // Persist credentials
      await _storage.write(key: _apiKeyStorageKey, value: _apiKey!);
      await _storage.write(key: _userIdStorageKey, value: _userId!);

      _authStateController.add(AuthState.authenticated);
      return _userId!;
    } catch (e) {
      _authStateController.add(AuthState.error);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    // Revoke API key on server (best effort)
    if (_apiKey != null) {
      try {
        await _postJson('/api/v1/timeshare/auth/logout/', {}, authenticated: true);
      } catch (e) {
        // Ignore errors - we're logging out anyway
        debugPrint('Logout API call failed: $e');
      }
    }

    // Clear local state
    _apiKey = null;
    _userId = null;
    await _storage.delete(key: _apiKeyStorageKey);
    await _storage.delete(key: _userIdStorageKey);

    _authStateController.add(AuthState.unauthenticated);
  }

  @override
  Future<bool> loadStoredCredentials() async {
    _authStateController.add(AuthState.loading);

    try {
      final storedApiKey = await _storage.read(key: _apiKeyStorageKey);
      final storedUserId = await _storage.read(key: _userIdStorageKey);

      if (storedApiKey != null && storedUserId != null) {
        _apiKey = storedApiKey;
        _userId = storedUserId;

        // Optionally validate the API key is still valid
        final isValid = await _validateApiKey();
        if (isValid) {
          _authStateController.add(AuthState.authenticated);
          return true;
        } else {
          // API key expired/revoked - clear credentials
          await logout();
          return false;
        }
      }

      _authStateController.add(AuthState.unauthenticated);
      return false;
    } catch (e) {
      debugPrint('Failed to load stored credentials: $e');
      _authStateController.add(AuthState.unauthenticated);
      return false;
    }
  }

  /// Validate the current API key by calling a lightweight endpoint.
  Future<bool> _validateApiKey() async {
    if (_apiKey == null) return false;

    try {
      await _getJson('/api/v1/timeshare/auth/me/', authenticated: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// POST JSON to the API.
  Future<String> _postJson(
    String path,
    Map<String, dynamic> body, {
    bool authenticated = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = await _httpClient.postUrl(uri);

    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');
    if (authenticated && _apiKey != null) {
      request.headers.set('Authorization', 'Api-Key $_apiKey');
    }

    request.write(jsonEncode(body));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode >= 400) {
      throw AuthException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(responseBody, response.statusCode),
      );
    }

    return responseBody;
  }

  /// GET JSON from the API.
  Future<String> _getJson(String path, {bool authenticated = false}) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = await _httpClient.getUrl(uri);

    request.headers.set('Accept', 'application/json');
    if (authenticated && _apiKey != null) {
      request.headers.set('Authorization', 'Api-Key $_apiKey');
    }

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode >= 400) {
      throw AuthException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(responseBody, response.statusCode),
      );
    }

    return responseBody;
  }

  String _extractErrorMessage(String body, int statusCode) {
    try {
      final json = jsonDecode(body);
      if (json is Map) {
        if (json.containsKey('detail')) return json['detail'];
        if (json.containsKey('message')) return json['message'];
        if (json.containsKey('error')) return json['error'];
        if (json.containsKey('non_field_errors')) {
          return (json['non_field_errors'] as List).join(', ');
        }
      }
    } catch (_) {}

    // User-friendly messages for common status codes
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Invalid email or password.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Account not found.';
      case 409:
        return 'An account with this email already exists.';
      case 429:
        return 'Too many attempts. Please try again later.';
      case >= 500:
        return 'Server error. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    if (_apiKey == null) {
      throw AuthException(
        statusCode: 401,
        message: 'Not authenticated',
      );
    }

    await _postJson(
      '/api/v1/timeshare/auth/change-password/',
      {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
      authenticated: true,
    );
  }

  @override
  Future<void> changeEmail(String newEmail, String password) async {
    if (_apiKey == null) {
      throw AuthException(
        statusCode: 401,
        message: 'Not authenticated',
      );
    }

    await _postJson(
      '/api/v1/timeshare/auth/change-email/',
      {
        'new_email': newEmail,
        'password': password,
      },
      authenticated: true,
    );
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    // This endpoint should always return success to prevent email enumeration
    try {
      await _postJson(
        '/api/v1/timeshare/auth/password-reset/',
        {'email': email},
      );
    } catch (e) {
      // Silently ignore errors to prevent email enumeration
      // The user will see a generic success message regardless
      debugPrint('Password reset request failed (suppressed): $e');
    }
  }

  /// Dispose of resources.
  void dispose() {
    _authStateController.close();
  }

  // Storage keys
  static const _apiKeyStorageKey = 'timeshare_api_key';
  static const _userIdStorageKey = 'timeshare_user_id';
}

/// Exception thrown during authentication.
class AuthException implements Exception {
  final int statusCode;
  final String message;

  AuthException({required this.statusCode, required this.message});

  @override
  String toString() => 'AuthException($statusCode): $message';
}

/// Abstract interface for secure storage.
///
/// This abstraction allows for:
/// - Easy testing with in-memory implementations
/// - Platform-specific secure storage implementations
abstract class SecureStorage {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String value});
  Future<void> delete({required String key});
  Future<void> deleteAll();
}

/// In-memory implementation for testing.
class InMemorySecureStorage implements SecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<String?> read({required String key}) async => _storage[key];

  @override
  Future<void> write({required String key, required String value}) async {
    _storage[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _storage.clear();
  }
}
