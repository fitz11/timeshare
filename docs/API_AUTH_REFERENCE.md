# API Authentication & Access Reference

This document provides a comprehensive reference for how authentication and API access work with the squishygoose.dev backend. Use this as a guide when implementing or troubleshooting API integration.

---

## Table of Contents

1. [Authentication Methods](#1-authentication-methods)
2. [API Key Lifecycle](#2-api-key-lifecycle)
3. [Making Authenticated Requests](#3-making-authenticated-requests)
4. [Error Responses](#4-error-responses)
5. [Rate Limiting](#5-rate-limiting)
6. [Security Considerations](#6-security-considerations)
7. [Implementation Patterns](#7-implementation-patterns)

---

## 1. Authentication Methods

The API supports **API Key authentication** for mobile/client apps.

### API Key Authentication

**Header Format**:
```
Authorization: Api-Key <your-api-key>
```

**Characteristics**:
- Keys are 43-character URL-safe base64 strings
- Keys are hashed (SHA-256) before storage - the server never stores plaintext keys
- Keys can be revoked without deletion (soft revocation)
- Each key tracks `last_used_at` for monitoring

**Example Request**:
```dart
final response = await http.get(
  Uri.parse('https://squishygoose.dev/api/v1/timeshare/calendars/'),
  headers: {
    'Authorization': 'Api-Key $apiKey',
    'Content-Type': 'application/json',
  },
);
```

---

## 2. API Key Lifecycle

### Generation (Registration)

```
POST /api/v1/timeshare/auth/register/
Content-Type: application/json

{
    "email": "user@example.com",
    "password": "secure_password_123",
    "display_name": "John Doe"
}
```

**Success Response** (201 Created):
```json
{
    "api_key": "8B5C7x2Q...<full-43-char-key>",
    "user": {
        "uid": "550e8400-e29b-41d4-a716-446655440000",
        "email": "user@example.com",
        "display_name": "John Doe",
        "friends": []
    }
}
```

**Important**: The `api_key` is returned **only at creation time**. Store it securely immediately - it cannot be retrieved later.

### Generation (Login)

```
POST /api/v1/timeshare/auth/login/
Content-Type: application/json

{
    "email": "user@example.com",
    "password": "secure_password_123"
}
```

**Success Response** (200 OK):
```json
{
    "api_key": "9D6E8y3R...<new-43-char-key>",
    "user": {
        "uid": "550e8400-e29b-41d4-a716-446655440000",
        "email": "user@example.com",
        "display_name": "John Doe",
        "friends": ["friend-uid-1", "friend-uid-2"]
    }
}
```

**Note**: Each login generates a **new** API key. Previous keys remain valid until explicitly revoked.

### Validation (Session Check)

```
GET /api/v1/timeshare/auth/me/
Authorization: Api-Key <your-api-key>
```

**Success Response** (200 OK):
```json
{
    "uid": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "display_name": "John Doe",
    "friends": ["friend-uid-1"]
}
```

Use this endpoint on app startup to validate stored credentials.

### Revocation (Logout)

```
POST /api/v1/timeshare/auth/logout/
Authorization: Api-Key <your-api-key>
```

**Success Response** (200 OK):
```json
{
    "success": true
}
```

After logout:
- The API key is marked inactive (`is_active=False`)
- Subsequent requests with that key return **401 Unauthorized**
- User must login again to get a new key

---

## 3. Making Authenticated Requests

### Request Headers

All authenticated requests require:

```
Authorization: Api-Key <your-api-key>
Content-Type: application/json
Accept: application/json
```

### Example: List Calendars

```dart
Future<List<Calendar>> getCalendars() async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/v1/timeshare/calendars/'),
    headers: {
      'Authorization': 'Api-Key $apiKey',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Calendar.fromJson(json)).toList();
  } else if (response.statusCode == 401) {
    throw AuthenticationException('Session expired');
  } else {
    throw ApiException('Failed to load calendars: ${response.statusCode}');
  }
}
```

### Example: Create Event

```dart
Future<Event> createEvent(String calendarId, Event event) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/v1/timeshare/calendars/$calendarId/events/'),
    headers: {
      'Authorization': 'Api-Key $apiKey',
      'Content-Type': 'application/json',
    },
    body: json.encode(event.toJson()),
  );

  if (response.statusCode == 201) {
    return Event.fromJson(json.decode(response.body));
  } else if (response.statusCode == 403) {
    throw PermissionException('No access to this calendar');
  } else {
    throw ApiException('Failed to create event');
  }
}
```

---

## 4. Error Responses

### Authentication Errors

| Status | Scenario | Response | Client Action |
|--------|----------|----------|---------------|
| **401** | Invalid/revoked API key | `{"detail": "Invalid API key"}` | Prompt re-login |
| **401** | Wrong email/password | `{"detail": "Invalid credentials"}` | Show error, allow retry |
| **403** | No auth header provided | `{"detail": "Authentication credentials were not provided."}` | Check auth header |

### Validation Errors (400 Bad Request)

```json
{
    "email": ["A user with this email already exists."],
    "password": ["Ensure this field has at least 8 characters."]
}
```

**Handling**:
```dart
if (response.statusCode == 400) {
  final errors = json.decode(response.body) as Map<String, dynamic>;
  // errors is field -> list of error messages
  final emailErrors = errors['email'] as List<dynamic>?;
  final passwordErrors = errors['password'] as List<dynamic>?;
  // Display to user
}
```

### Permission Errors (403 Forbidden)

```json
{
    "detail": "You don't have access to this calendar"
}
```

Occurs when:
- Trying to access a calendar you don't own and aren't shared with
- Trying to delete/share a calendar you don't own
- Trying to modify another user's profile

### Not Found (404)

```json
{
    "detail": "Not found."
}
```

Occurs when:
- Calendar/event/user doesn't exist
- Resource was deleted

### Rate Limited (429 Too Many Requests)

```json
{
    "error": "Too many requests",
    "detail": "You have been temporarily blocked due to suspicious activity.",
    "retry_after": 60
}
```

**Headers**:
```
Retry-After: 60
```

**Handling**:
```dart
if (response.statusCode == 429) {
  final retryAfter = int.tryParse(response.headers['retry-after'] ?? '60') ?? 60;
  // Wait and retry, or show user message
  await Future.delayed(Duration(seconds: retryAfter));
}
```

### Server Error (500)

```json
{
    "detail": "Internal server error"
}
```

**Client Action**: Retry with exponential backoff, or show generic error.

---

## 5. Rate Limiting

### Standard Limits

| User Type | Limit | Scope |
|-----------|-------|-------|
| Anonymous | 100 requests/hour | Per IP |
| Authenticated | 1000 requests/hour | Per user |
| Auth endpoints | 10 requests/minute | Per IP |

### Abuse Detection (Progressive Throttling)

The API uses progressive throttling for suspicious behavior:

| Tier | Duration | Trigger |
|------|----------|---------|
| 1 | 1 minute | 5 failed auth attempts or injection patterns |
| 2 | 5 minutes | 10 cumulative violations |
| 3 | 1 hour | 20 cumulative violations |

**Automatic Recovery**: Violation counts decay at 1 point per minute.

### What Triggers Abuse Detection

1. **Authentication failures**: Wrong password, invalid API key
2. **Injection attempts**: SQL injection, XSS, command injection patterns
3. **Excessive 4xx errors**: Too many bad requests

### Best Practices

```dart
class ApiClient {
  int _consecutiveFailures = 0;
  DateTime? _backoffUntil;

  Future<Response> request(String path) async {
    // Check if in backoff period
    if (_backoffUntil != null && DateTime.now().isBefore(_backoffUntil!)) {
      throw RateLimitException('Please wait before retrying');
    }

    final response = await _makeRequest(path);

    if (response.statusCode == 429) {
      final retryAfter = int.parse(response.headers['retry-after'] ?? '60');
      _backoffUntil = DateTime.now().add(Duration(seconds: retryAfter));
      throw RateLimitException('Rate limited for $retryAfter seconds');
    }

    if (response.statusCode >= 400) {
      _consecutiveFailures++;
      if (_consecutiveFailures > 3) {
        // Implement client-side backoff to avoid server-side blocking
        await Future.delayed(Duration(seconds: _consecutiveFailures * 2));
      }
    } else {
      _consecutiveFailures = 0;
    }

    return response;
  }
}
```

---

## 6. Security Considerations

### Secure Storage

**Flutter Implementation**:
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureCredentialStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: 'api_key', value: apiKey);
  }

  Future<String?> getApiKey() async {
    return await _storage.read(key: 'api_key');
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: 'api_key');
  }
}
```

### Never Log Sensitive Data

```dart
// BAD - Don't do this
logger.info('Making request with key: $apiKey');

// GOOD - Log safely
logger.info('Making request to: $endpoint');
```

### Validate Server Certificates

```dart
// For development/testing only
// In production, always validate certificates
HttpClient client = HttpClient()
  ..badCertificateCallback = (cert, host, port) => false; // Reject bad certs
```

### Handle Token Expiration Gracefully

```dart
class AuthenticatedApiClient {
  Future<Response> request(String path) async {
    var response = await _makeAuthenticatedRequest(path);

    if (response.statusCode == 401) {
      // Token expired or revoked
      await _clearStoredCredentials();
      _notifyAuthStateChanged(AuthState.unauthenticated);
      throw SessionExpiredException();
    }

    return response;
  }
}
```

---

## 7. Implementation Patterns

### Auth Service Pattern

```dart
abstract class AuthService {
  Stream<AuthState> get authStateChanges;
  Future<User> register(String email, String password, String displayName);
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> validateSession();
}

class RestApiAuthService implements AuthService {
  final ApiClient _client;
  final SecureCredentialStorage _storage;
  final _authStateController = StreamController<AuthState>.broadcast();

  @override
  Stream<AuthState> get authStateChanges => _authStateController.stream;

  @override
  Future<User> login(String email, String password) async {
    final response = await _client.post('/auth/login/', {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _storage.saveApiKey(data['api_key']);
      _authStateController.add(AuthState.authenticated);
      return User.fromJson(data['user']);
    } else if (response.statusCode == 401) {
      throw InvalidCredentialsException();
    } else {
      throw AuthException('Login failed: ${response.statusCode}');
    }
  }

  @override
  Future<bool> validateSession() async {
    final apiKey = await _storage.getApiKey();
    if (apiKey == null) return false;

    try {
      final response = await _client.get('/auth/me/');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
```

### Retry with Exponential Backoff

```dart
Future<Response> requestWithRetry(
  Future<Response> Function() request, {
  int maxRetries = 3,
}) async {
  int attempt = 0;

  while (true) {
    try {
      final response = await request();

      if (response.statusCode >= 500 && attempt < maxRetries) {
        attempt++;
        await Future.delayed(Duration(seconds: pow(2, attempt).toInt()));
        continue;
      }

      return response;
    } catch (e) {
      if (attempt >= maxRetries) rethrow;
      attempt++;
      await Future.delayed(Duration(seconds: pow(2, attempt).toInt()));
    }
  }
}
```

### HTTP Client with Auth Header Injection

```dart
class AuthenticatedHttpClient {
  final SecureCredentialStorage _storage;
  final http.Client _client;

  Future<http.Response> get(Uri url) async {
    return _client.get(url, headers: await _buildHeaders());
  }

  Future<http.Response> post(Uri url, {Object? body}) async {
    return _client.post(
      url,
      headers: await _buildHeaders(),
      body: body is String ? body : json.encode(body),
    );
  }

  Future<Map<String, String>> _buildHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final apiKey = await _storage.getApiKey();
    if (apiKey != null) {
      headers['Authorization'] = 'Api-Key $apiKey';
    }

    return headers;
  }
}
```

### Centralized Error Handling

```dart
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? errors;

  ApiException(this.statusCode, this.message, [this.errors]);

  factory ApiException.fromResponse(http.Response response) {
    final body = json.decode(response.body);

    if (body is Map<String, dynamic>) {
      // Could be validation errors or detail message
      if (body.containsKey('detail')) {
        return ApiException(response.statusCode, body['detail']);
      } else {
        // Validation errors
        return ApiException(response.statusCode, 'Validation error', body);
      }
    }

    return ApiException(response.statusCode, 'Unknown error');
  }

  bool get isAuthError => statusCode == 401;
  bool get isPermissionError => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isRateLimited => statusCode == 429;
  bool get isValidationError => statusCode == 400 && errors != null;
  bool get isServerError => statusCode >= 500;
}
```

---

## API Endpoint Reference

### Authentication

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/v1/timeshare/auth/register/` | None | Create account, returns API key |
| POST | `/api/v1/timeshare/auth/login/` | None | Login, returns API key |
| POST | `/api/v1/timeshare/auth/logout/` | Required | Revoke current API key |
| GET | `/api/v1/timeshare/auth/me/` | Required | Get current user info |

### Calendars

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/api/v1/timeshare/calendars/` | Required | List owned + shared calendars |
| POST | `/api/v1/timeshare/calendars/` | Required | Create calendar |
| GET | `/api/v1/timeshare/calendars/{id}/` | Required | Get calendar (owner or shared) |
| DELETE | `/api/v1/timeshare/calendars/{id}/` | Required | Delete calendar (owner only) |
| POST | `/api/v1/timeshare/calendars/{id}/share/` | Required | Share calendar (owner only) |
| POST | `/api/v1/timeshare/calendars/{id}/unshare/` | Required | Unshare calendar (owner only) |

### Events

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/api/v1/timeshare/calendars/{id}/events/` | Required | List events in calendar |
| POST | `/api/v1/timeshare/calendars/{id}/events/` | Required | Create event |
| GET | `/api/v1/timeshare/calendars/{id}/events/{eid}/` | Required | Get event |
| PUT | `/api/v1/timeshare/calendars/{id}/events/{eid}/` | Required | Update event |
| DELETE | `/api/v1/timeshare/calendars/{id}/events/{eid}/` | Required | Delete event |

### Users

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/api/v1/timeshare/users/{uid}/` | Required | Get user profile |
| PATCH | `/api/v1/timeshare/users/{uid}/` | Required | Update profile (self only) |
| DELETE | `/api/v1/timeshare/users/{uid}/` | Required | Delete account (self only) |
| GET | `/api/v1/timeshare/users/{uid}/friends/` | Required | Get friends list |
| POST | `/api/v1/timeshare/users/{uid}/friends/{target}/` | Required | Add friend |
| DELETE | `/api/v1/timeshare/users/{uid}/friends/{target}/` | Required | Remove friend |
| GET | `/api/v1/timeshare/users/search/?email=...` | Required | Search users by email |

---

## Quick Reference

### Status Codes

| Code | Meaning | Common Cause |
|------|---------|--------------|
| 200 | OK | Successful GET/PATCH |
| 201 | Created | Successful POST |
| 204 | No Content | Successful DELETE |
| 400 | Bad Request | Validation errors |
| 401 | Unauthorized | Invalid/missing API key |
| 403 | Forbidden | No permission for resource |
| 404 | Not Found | Resource doesn't exist |
| 429 | Too Many Requests | Rate limited |
| 500 | Server Error | Backend issue |

### Common Headers

**Request**:
```
Authorization: Api-Key <key>
Content-Type: application/json
Accept: application/json
```

**Response** (rate limit):
```
Retry-After: <seconds>
```
