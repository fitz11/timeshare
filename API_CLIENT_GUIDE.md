# API Client Guide (Flutter/Mobile)

This guide covers integrating with the squishygoose.dev Timeshare API from Flutter or other mobile clients.

## Base URL

- **Production**: `https://squishygoose.dev/api/v1/timeshare/`
- **Development**: `http://localhost:8000/api/v1/timeshare/`

## Authentication

The API uses API key authentication. Include your API key in the `Authorization` header:

```
Authorization: Api-Key <your-api-key>
```

## Registration Flow (with Email Verification)

Registration now requires email verification before the API key is issued.

### Step 1: Register

```http
POST /api/v1/timeshare/auth/register/
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securepassword123",
  "display_name": "User Name"  // optional
}
```

**Response (201 Created):**
```json
{
  "message": "Registration successful. Please check your email to verify your account.",
  "email": "user@example.com"
}
```

Note: No `api_key` is returned at this stage.

### Step 2: User Verifies Email

The user receives an email with a verification link:
```
https://squishygoose.dev/accounts/verify-email/<token>/
```

**Option A: Web Verification (Recommended)**

User clicks the link in their email, which opens the web browser and verifies their email. They are automatically logged in on the web.

**Option B: API Verification (for in-app flow)**

If you want to handle verification in-app, extract the token from the deep link and call:

```http
POST /api/v1/timeshare/auth/verify-email/
Content-Type: application/json

{
  "token": "<token-from-verification-link>"
}
```

**Response (200 OK):**
```json
{
  "api_key": "your-api-key-here",
  "user": {
    "uid": "uuid-here",
    "email": "user@example.com",
    "display_name": "User Name",
    "photo_url": null,
    "date_joined": "2026-01-13T12:00:00Z"
  }
}
```

### Step 3: Store API Key

Store the API key securely using platform-specific secure storage:

**Flutter:**
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
await storage.write(key: 'api_key', value: apiKey);
```

### Deep Link Handling (Flutter)

To handle verification links in-app:

```dart
// AndroidManifest.xml
<intent-filter>
  <action android:name="android.intent.action.VIEW"/>
  <category android:name="android.intent.category.DEFAULT"/>
  <category android:name="android.intent.category.BROWSABLE"/>
  <data android:scheme="https"
        android:host="squishygoose.dev"
        android:pathPrefix="/accounts/verify-email/"/>
</intent-filter>

// In your app
void handleDeepLink(Uri uri) async {
  if (uri.pathSegments.contains('verify-email')) {
    final token = uri.pathSegments.last;
    final response = await api.verifyEmail(token);
    if (response.statusCode == 200) {
      // Store API key and navigate to home
      await storage.write(key: 'api_key', value: response.data['api_key']);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
```

---

## Login

```http
POST /api/v1/timeshare/auth/login/
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securepassword123"
}
```

**Success Response (200 OK):**
```json
{
  "api_key": "new-api-key-here",
  "user": {
    "uid": "uuid-here",
    "email": "user@example.com",
    "display_name": "User Name",
    "photo_url": null,
    "date_joined": "2026-01-13T12:00:00Z"
  }
}
```

**Email Not Verified (403 Forbidden):**
```json
{
  "detail": "Email not verified. Please check your email for the verification link.",
  "email_not_verified": true
}
```

When you receive this response, prompt the user to check their email or offer to resend the verification email.

---

## Resend Verification Email

```http
POST /api/v1/timeshare/auth/resend-verification/
Content-Type: application/json

{
  "email": "user@example.com"
}
```

**Response (200 OK):**
```json
{
  "detail": "If an unverified account exists, a verification link has been sent."
}
```

Note: Always returns 200 to prevent email enumeration.

---

## Authentication Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/auth/register/` | POST | No | Register new user (sends verification email) |
| `/auth/verify-email/` | POST | No | Verify email with token, returns API key |
| `/auth/resend-verification/` | POST | No | Resend verification email |
| `/auth/login/` | POST | No | Login (requires verified email), returns API key |
| `/auth/logout/` | POST | Yes | Revoke current API key |
| `/auth/me/` | GET | Yes | Get current user details |
| `/auth/change-password/` | POST | Yes | Change password |
| `/auth/change-email/` | POST | Yes | Request email change |
| `/auth/password-reset/` | POST | No | Request password reset email |

---

## Calendar Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/calendars/` | GET | Yes | List all calendars (owned + shared) |
| `/calendars/` | POST | Yes | Create new calendar |
| `/calendars/{id}/` | GET | Yes | Get calendar details |
| `/calendars/{id}/` | PUT | Yes | Update calendar (owner only) |
| `/calendars/{id}/` | DELETE | Yes | Delete calendar (owner only) |
| `/calendars/{id}/share/` | POST | Yes | Share/unshare calendar (owner only) |
| `/calendars/{id}/events/` | GET | Yes | List calendar events |
| `/calendars/{id}/events/` | POST | Yes | Create event |
| `/calendars/{id}/events/{event_id}/` | GET | Yes | Get event details |
| `/calendars/{id}/events/{event_id}/` | PUT | Yes | Update event |
| `/calendars/{id}/events/{event_id}/` | DELETE | Yes | Delete event |

---

## User Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/users/search/` | GET | Yes | Search users by email |
| `/users/{uid}/` | GET | Yes | Get user details |
| `/users/{uid}/friends/` | GET | Yes | List user's friends |
| `/users/{uid}/friends/{target_uid}/` | DELETE | Yes | Remove friend |

---

## Friend Request Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/friend-requests/` | POST | Yes | Send friend request |
| `/friend-requests/incoming/` | GET | Yes | List incoming requests |
| `/friend-requests/sent/` | GET | Yes | List sent requests |
| `/friend-requests/{id}/accept/` | POST | Yes | Accept request |
| `/friend-requests/{id}/decline/` | POST | Yes | Decline request |
| `/friend-requests/{id}/cancel/` | POST | Yes | Cancel sent request |

---

## Ownership Transfer Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/ownership-transfers/` | POST | Yes | Request calendar ownership transfer |
| `/ownership-transfers/{id}/accept/` | POST | Yes | Accept transfer |
| `/ownership-transfers/{id}/decline/` | POST | Yes | Decline transfer |
| `/ownership-transfers/{id}/cancel/` | POST | Yes | Cancel transfer request |

---

## Response Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 204 | No content (successful delete) |
| 400 | Bad request (validation error) |
| 401 | Unauthorized (invalid/missing API key) |
| 403 | Forbidden (email not verified, or not owner) |
| 404 | Not found |
| 409 | Conflict (version mismatch) |
| 429 | Rate limited |

---

## Error Handling

### Email Not Verified (403)

```json
{
  "detail": "Email not verified. Please check your email for the verification link.",
  "email_not_verified": true
}
```

**Action:** Prompt user to check their email or resend verification.

### Version Conflict (409)

```json
{
  "detail": "Version conflict",
  "current_state": {
    "id": "uuid",
    "name": "Calendar Name",
    "version": 5,
    ...
  }
}
```

**Action:** Merge local changes with server state and retry with new version.

### Rate Limited (429)

```json
{
  "detail": "Request was throttled. Expected available in 60 seconds."
}
```

**Action:** Implement exponential backoff before retrying.

---

## Version Conflict Resolution

Calendars and events use optimistic locking. Include `version` in update requests:

```http
PUT /api/v1/timeshare/calendars/{id}/
Content-Type: application/json

{
  "name": "Updated Name",
  "version": 3
}
```

If the server version doesn't match, you'll receive a 409 with the current state.

---

## Rate Limits

| Endpoint Type | Rate |
|--------------|------|
| Authentication | 10 requests/minute |
| General API | 100 requests/hour (anonymous), 1000/hour (authenticated) |

---

## Security Best Practices

1. **Store API keys securely** - Use platform secure storage, never plain text
2. **Handle 401 responses** - Clear stored credentials and prompt re-login
3. **Implement exponential backoff** - For rate-limited requests
4. **Use HTTPS** - Never make requests over plain HTTP
5. **Don't log sensitive data** - API keys, passwords, tokens

---

## Example: Complete Registration Flow (Dart)

```dart
class AuthService {
  final http.Client client;
  final FlutterSecureStorage storage;

  Future<void> register(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      // Registration successful, show verification pending screen
      return;
    }
    throw AuthException(response.body);
  }

  Future<String> verifyEmail(String token) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/verify-email/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final apiKey = data['api_key'];
      await storage.write(key: 'api_key', value: apiKey);
      return apiKey;
    }
    throw AuthException(response.body);
  }

  Future<String?> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final apiKey = data['api_key'];
      await storage.write(key: 'api_key', value: apiKey);
      return apiKey;
    }

    if (response.statusCode == 403) {
      final data = jsonDecode(response.body);
      if (data['email_not_verified'] == true) {
        throw EmailNotVerifiedException();
      }
    }

    throw AuthException(response.body);
  }
}
```
