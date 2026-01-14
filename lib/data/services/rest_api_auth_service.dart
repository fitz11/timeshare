// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:timeshare/data/exceptions/email_not_verified_exception.dart';
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
  final http.Client _httpClient;
  final SecureStorage _storage;

  String? _apiKey;
  String? _userId;
  String? _pendingVerificationEmail;
  final _authStateController = StreamController<AuthState>.broadcast();

  RestApiAuthService({
    required this.baseUrl,
    required SecureStorage storage,
    http.Client? httpClient,
  })  : _storage = storage,
        _httpClient = httpClient ?? http.Client();

  @override
  String? get apiKey => _apiKey;

  @override
  String? get currentUserId => _userId;

  @override
  Stream<AuthState> get authStateStream => _authStateController.stream;

  @override
  String? get pendingVerificationEmail => _pendingVerificationEmail;

  @override
  Future<String> login(String email, String password) async {
    try {
      _authStateController.add(AuthState.loading);
      final (statusCode, responseBody) =
          await _postJsonWithStatus('/api/v1/timeshare/auth/login/', {
        'email': email,
        'password': password,
      });

      if (statusCode == 200) {
        final data = jsonDecode(responseBody);
        if (data is! Map<String, dynamic>) {
          throw AuthException(
              statusCode: 500, message: 'Invalid response format');
        }
        final apiKey = data['api_key'] as String?;
        if (apiKey == null) {
          throw AuthException(statusCode: 500, message: 'Missing api_key');
        }
        final user = data['user'] as Map<String, dynamic>?;
        if (user == null) {
          throw AuthException(statusCode: 500, message: 'Missing user data');
        }
        final uid = user['uid'] as String?;
        if (uid == null) {
          throw AuthException(statusCode: 500, message: 'Missing user uid');
        }
        _apiKey = apiKey;
        _userId = uid;

        // Persist credentials
        await _storage.write(key: _apiKeyStorageKey, value: _apiKey!);
        await _storage.write(key: _userIdStorageKey, value: _userId!);

        _authStateController.add(AuthState.authenticated);
        return _userId!;
      }

      if (statusCode == 403) {
        final data = jsonDecode(responseBody);
        if (data['email_not_verified'] == true) {
          _authStateController.add(AuthState.unauthenticated);
          throw EmailNotVerifiedException(email: email);
        }
      }

      _authStateController.add(AuthState.error);
      throw AuthException(
        statusCode: statusCode,
        message: _extractErrorMessage(responseBody, statusCode),
      );
    } on EmailNotVerifiedException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Login error (${e.runtimeType}): $e');
      debugPrint('Login stack trace: $stackTrace');
      _authStateController.add(AuthState.error);
      throw AuthException(
        statusCode: 0,
        message: 'Unable to connect to server. Please check your internet connection.',
      );
    }
  }

  @override
  Future<String> signup(
      String email, String password, String displayName) async {
    try {
      _authStateController.add(AuthState.loading);
      final (statusCode, responseBody) =
          await _postJsonWithStatus('/api/v1/timeshare/auth/register/', {
        'email': email,
        'password': password,
        'display_name': displayName,
      });

      if (statusCode == 201) {
        // Registration successful, email verification required
        _pendingVerificationEmail = email;
        await _storage.write(key: _pendingEmailStorageKey, value: email);
        _authStateController.add(AuthState.pendingVerification);
        return ''; // No user ID yet - must verify email first
      }

      _authStateController.add(AuthState.error);
      throw AuthException(
        statusCode: statusCode,
        message: _extractErrorMessage(responseBody, statusCode),
      );
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Signup error (${e.runtimeType}): $e');
      debugPrint('Signup stack trace: $stackTrace');
      _authStateController.add(AuthState.error);
      throw AuthException(
        statusCode: 0,
        message: 'Unable to connect to server. Please check your internet connection.',
      );
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
    try {
      _authStateController.add(AuthState.loading);
      // Check for pending verification first
      final pendingEmail = await _storage.read(key: _pendingEmailStorageKey);
      if (pendingEmail != null) {
        _pendingVerificationEmail = pendingEmail;
        _authStateController.add(AuthState.pendingVerification);
        return false;
      }

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
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authenticated && _apiKey != null) {
      headers['Authorization'] = 'Api-Key $_apiKey';
    }

    final response = await _httpClient.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw AuthException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(response.body, response.statusCode),
      );
    }

    return response.body;
  }

  /// POST JSON to the API and return both status code and body.
  Future<(int, String)> _postJsonWithStatus(
    String path,
    Map<String, dynamic> body, {
    bool authenticated = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authenticated && _apiKey != null) {
      headers['Authorization'] = 'Api-Key $_apiKey';
    }

    final response = await _httpClient.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    return (response.statusCode, response.body);
  }

  /// GET JSON from the API.
  Future<String> _getJson(String path, {bool authenticated = false}) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (authenticated && _apiKey != null) {
      headers['Authorization'] = 'Api-Key $_apiKey';
    }

    final response = await _httpClient.get(uri, headers: headers);

    if (response.statusCode >= 400) {
      throw AuthException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(response.body, response.statusCode),
      );
    }

    return response.body;
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

  @override
  Future<String> verifyEmail(String token) async {
    try {
      _authStateController.add(AuthState.loading);
      final response = await _postJson(
        '/api/v1/timeshare/auth/verify-email/',
        {'token': token},
      );

      final data = jsonDecode(response);
      if (data is! Map<String, dynamic>) {
        throw AuthException(statusCode: 500, message: 'Invalid response format');
      }
      final apiKey = data['api_key'] as String?;
      if (apiKey == null) {
        throw AuthException(statusCode: 500, message: 'Missing api_key');
      }
      final user = data['user'] as Map<String, dynamic>?;
      if (user == null) {
        throw AuthException(statusCode: 500, message: 'Missing user data');
      }
      final uid = user['uid'] as String?;
      if (uid == null) {
        throw AuthException(statusCode: 500, message: 'Missing user uid');
      }
      _apiKey = apiKey;
      _userId = uid;

      // Clear pending state
      _pendingVerificationEmail = null;
      await _storage.delete(key: _pendingEmailStorageKey);

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
  Future<void> resendVerificationEmail(String email) async {
    try {
      await _postJson(
        '/api/v1/timeshare/auth/resend-verification/',
        {'email': email},
      );
    } catch (e) {
      // Silently ignore errors to prevent email enumeration
      debugPrint('Resend verification request failed (suppressed): $e');
    }
  }

  @override
  void cancelPendingVerification() {
    _pendingVerificationEmail = null;
    _storage.delete(key: _pendingEmailStorageKey);
    _authStateController.add(AuthState.unauthenticated);
  }

  /// Dispose of resources.
  void dispose() {
    _authStateController.close();
  }

  // Storage keys
  static const _apiKeyStorageKey = 'timeshare_api_key';
  static const _userIdStorageKey = 'timeshare_user_id';
  static const _pendingEmailStorageKey = 'timeshare_pending_verification_email';
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
