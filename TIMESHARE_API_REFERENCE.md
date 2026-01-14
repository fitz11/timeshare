# Timeshare API Reference

Complete API documentation for the squishygoose.dev Timeshare calendar sharing service.

## Table of Contents

- [Overview](#overview)
- [Authentication](#authentication)
- [Rate Limiting](#rate-limiting)
- [Response Format](#response-format)
- [Authentication Endpoints](#authentication-endpoints)
- [User Endpoints](#user-endpoints)
- [Calendar Endpoints](#calendar-endpoints)
- [Event Endpoints](#event-endpoints)
- [Friend Request Endpoints](#friend-request-endpoints)
- [Ownership Transfer Endpoints](#ownership-transfer-endpoints)
- [Error Handling](#error-handling)

---

## Overview

### Base URLs

| Environment | URL |
|-------------|-----|
| Production | `https://squishygoose.dev/api/v1/timeshare/` |
| Development | `http://localhost:8000/api/v1/timeshare/` |

### API Versioning

The API uses URL-based versioning. Current version: `v1`

### Content Type

All requests must include:
```
Content-Type: application/json
```

---

## Authentication

### Methods

The API supports three authentication methods:

1. **API Key** (Primary for mobile/service clients)
   ```
   Authorization: Api-Key tshr_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```

2. **Session** (For web browser clients)
   - Django session cookie authentication
   - Sessions stored in Redis

3. **JWT** (Alternative token auth)
   ```
   Authorization: Bearer <jwt-token>
   ```

### API Key Format

- Prefix: `tshr_`
- Total length: 36 characters
- Example: `tshr_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

### Obtaining an API Key

1. Register a new account (`POST /auth/register/`)
2. Verify email via link or `POST /auth/verify-email/`
3. API key returned upon successful verification
4. Subsequent logins (`POST /auth/login/`) issue new API keys

---

## Rate Limiting

| Endpoint Type | Rate Limit |
|---------------|------------|
| Authentication endpoints | 10 requests/minute |
| Public endpoints | 60 requests/minute |
| Authenticated general | 100 requests/hour per user |

All endpoints include abuse detection that may throttle excessive requests from a single IP.

### Rate Limit Headers

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1705234567
```

---

## Response Format

### JSON Casing

The API uses `djangorestframework-camel-case` for automatic casing conversion.

**Responses** always use **camelCase**:
- `displayName` (not `display_name`)
- `photoUrl` (not `photo_url`)
- `createdAt` (not `created_at`)

**Requests** accept both camelCase and snake_case:
- The parser converts incoming `camelCase` → `snake_case` for backend processing
- Incoming `snake_case` passes through unchanged
- Both `{"displayName": "John"}` and `{"display_name": "John"}` are valid

**Recommended**: Use camelCase in requests for consistency with responses.

### Standard Success Responses

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 204 | No Content (successful delete) |

### Standard Error Responses

| Code | Meaning |
|------|---------|
| 400 | Bad Request (validation error) |
| 401 | Unauthorized (invalid/missing credentials) |
| 403 | Forbidden (insufficient permissions) |
| 404 | Not Found |
| 409 | Conflict (version mismatch) |
| 429 | Too Many Requests (rate limited) |

---

## Authentication Endpoints

### POST /auth/register/

Register a new user account. Sends verification email.

**Authentication:** None

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securepassword123",
  "displayName": "John Doe"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | string | Yes | Valid email address |
| password | string | Yes | Minimum 8 characters |
| displayName | string | No | User's display name |

**Response 201 (Success):**
```json
{
  "message": "Registration successful. Please check your email to verify your account.",
  "email": "user@example.com"
}
```

**Response 201 (Email Send Failed):**
```json
{
  "message": "Registration successful but verification email could not be sent. Please use 'Resend verification email' to try again.",
  "email": "user@example.com",
  "emailSendFailed": true
}
```

**Response 409 (Unverified Account Exists):**
```json
{
  "emailNotVerified": true,
  "email": "user@example.com",
  "detail": "An account with this email exists but is not verified."
}
```

**Response 400 (Validation Error):**
```json
{
  "email": ["A user with that email already exists."]
}
```

---

### POST /auth/verify-email/

Verify email address and receive API key.

**Authentication:** None

**Request Body:**
```json
{
  "token": "verification-token-from-email"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| token | string | Yes | Token from verification email link |

**Response 200 (Success):**
```json
{
  "apiKey": "tshr_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "user": {
    "uid": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "displayName": "John Doe",
    "photoUrl": null,
    "dateJoined": "2026-01-14T10:00:00Z"
  }
}
```

**Response 400 (Invalid Token):**
```json
{
  "detail": "Invalid token"
}
```

**Response 400 (Expired Token):**
```json
{
  "detail": "Token has expired or has already been used"
}
```

**Notes:**
- Tokens expire after 24 hours
- Tokens are single-use
- Creating a new token invalidates previous tokens

---

### POST /auth/resend-verification/

Resend verification email.

**Authentication:** None

**Request Body:**
```json
{
  "email": "user@example.com"
}
```

**Response 200 (Always):**
```json
{
  "detail": "If an unverified account exists, a verification link has been sent."
}
```

**Notes:**
- Always returns 200 to prevent email enumeration
- Silently ignores non-existent or already-verified accounts
- Rate limited to 10 requests/minute

---

### POST /auth/login/

Login and receive a new API key.

**Authentication:** None

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securepassword123"
}
```

**Response 200 (Success):**
```json
{
  "apiKey": "tshr_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "user": {
    "uid": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "displayName": "John Doe",
    "photoUrl": null,
    "dateJoined": "2026-01-14T10:00:00Z"
  }
}
```

**Response 401 (Invalid Credentials):**
```json
{
  "detail": "Invalid credentials"
}
```

**Response 403 (Email Not Verified):**
```json
{
  "detail": "Email not verified. Please check your email for the verification link.",
  "emailNotVerified": true
}
```

**Notes:**
- Generates a new API key on each login
- Previous API keys remain valid until explicitly revoked
- Returns 401 for both non-existent email and wrong password (security measure)

---

### POST /auth/logout/

Revoke the current API key.

**Authentication:** Required

**Request Body:** Empty

**Response 200:**
```json
{
  "success": true
}
```

**Notes:**
- Only revokes the API key used for this request
- User can login again to get a new API key

---

### GET /auth/me/

Get current authenticated user details.

**Authentication:** Required

**Response 200:**
```json
{
  "uid": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "displayName": "John Doe",
  "photoUrl": "https://example.com/photo.jpg",
  "dateJoined": "2026-01-14T10:00:00Z",
  "friends": [
    "660e8400-e29b-41d4-a716-446655440001",
    "770e8400-e29b-41d4-a716-446655440002"
  ]
}
```

---

### POST /auth/change-password/

Change authenticated user's password.

**Authentication:** Required

**Request Body:**
```json
{
  "currentPassword": "oldpassword123",
  "newPassword": "newsecurepassword456"
}
```

**Response 200:**
```json
{
  "detail": "Password changed successfully"
}
```

**Response 400 (Wrong Password):**
```json
{
  "detail": "Current password is incorrect"
}
```

---

### POST /auth/change-email/

Request email change (sends verification to new email).

**Authentication:** Required

**Request Body:**
```json
{
  "newEmail": "newemail@example.com",
  "password": "currentpassword123"
}
```

**Response 200:**
```json
{
  "detail": "Verification email sent. Please check your new email address."
}
```

**Response 400 (Wrong Password):**
```json
{
  "detail": "Password is incorrect"
}
```

**Notes:**
- Creates an EmailChangeRequest with verification token
- User must confirm from new email before email updates
- Token expires after 24 hours

---

### POST /auth/password-reset/

Request password reset email.

**Authentication:** None

**Request Body:**
```json
{
  "email": "user@example.com"
}
```

**Response 200 (Always):**
```json
{
  "detail": "If an account exists with this email, you will receive a password reset link."
}
```

**Notes:**
- Always returns 200 to prevent email enumeration
- Uses Django's password reset token generator

---

## User Endpoints

### GET /users/search/

Search users by email prefix.

**Authentication:** Required

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| email | string | Yes | Email prefix (minimum 5 characters) |

**Example:** `GET /users/search/?email=john@`

**Response 200:**
```json
[
  {
    "uid": "550e8400-e29b-41d4-a716-446655440000",
    "email": "john@example.com",
    "displayName": "John Doe",
    "photoUrl": null
  }
]
```

**Notes:**
- Returns maximum 10 results
- Minimum prefix length: 5 characters
- Excludes current user from results

---

### GET /users/{uid}/

Get user profile by UID.

**Authentication:** Required

**URL Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| uid | UUID | User's unique identifier |

**Response 200:**
```json
{
  "uid": "550e8400-e29b-41d4-a716-446655440000",
  "email": "john@example.com",
  "displayName": "John Doe",
  "photoUrl": null,
  "dateJoined": "2026-01-14T10:00:00Z",
  "friends": ["660e8400-e29b-41d4-a716-446655440001"]
}
```

---

### PATCH /users/{uid}/

Update user profile. Users can only update their own profile.

**Authentication:** Required

**Permissions:** Self only

**Request Body:**
```json
{
  "displayName": "John Smith",
  "photoUrl": "https://example.com/newphoto.jpg"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| displayName | string | No | New display name |
| photoUrl | string | No | New profile photo URL |

**Response 200:** Updated user object

**Response 403:** Attempting to update another user's profile

---

### DELETE /users/{uid}/

Delete user account. Users can only delete their own account.

**Authentication:** Required

**Permissions:** Self only

**Response 204:** No content

**Notes:**
- Cascading delete: all owned calendars, events, API keys
- Removes user from shared calendars
- Removes from all friends lists
- Atomic transaction

---

### GET /users/{uid}/friends/

List a user's friends.

**Authentication:** Required

**Response 200:**
```json
[
  {
    "uid": "660e8400-e29b-41d4-a716-446655440001",
    "email": "friend@example.com",
    "displayName": "Friend Name",
    "photoUrl": null,
    "dateJoined": "2026-01-10T10:00:00Z"
  }
]
```

---

### POST /users/{uid}/friends/{target_uid}/

Add a user as friend.

**Authentication:** Required

**Permissions:** Can only modify own friends list

**Response 201:**
```json
{
  "success": true
}
```

---

### DELETE /users/{uid}/friends/{target_uid}/

Remove a friend.

**Authentication:** Required

**Permissions:** Can only modify own friends list

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| cascade | boolean | false | If true, revokes all calendar sharing |

**Example:** `DELETE /users/{uid}/friends/{target_uid}/?cascade=true`

**Response 204:** No content

**Notes:**
- Removes from both users' friends lists (bidirectional)
- With `cascade=true`: revokes all calendar sharing between users

---

## Calendar Endpoints

### GET /calendars/

List all calendars accessible to the current user.

**Authentication:** Required

**Response 200:**
```json
[
  {
    "id": "880e8400-e29b-41d4-a716-446655440000",
    "name": "My Calendar",
    "owner": "550e8400-e29b-41d4-a716-446655440000",
    "sharedWith": [
      "660e8400-e29b-41d4-a716-446655440001"
    ],
    "createdAt": "2026-01-14T10:00:00Z",
    "version": 1
  }
]
```

**Notes:**
- Returns both owned and shared calendars
- Sorted by `createdAt` descending (newest first)

---

### POST /calendars/

Create a new calendar.

**Authentication:** Required

**Request Body:**
```json
{
  "name": "Work Calendar"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| name | string | Yes | Calendar name (max 100 characters) |

**Response 201:**
```json
{
  "id": "880e8400-e29b-41d4-a716-446655440000",
  "name": "Work Calendar",
  "owner": "550e8400-e29b-41d4-a716-446655440000",
  "sharedWith": [],
  "createdAt": "2026-01-14T10:00:00Z",
  "version": 1
}
```

---

### GET /calendars/{id}/

Get a single calendar.

**Authentication:** Required

**Permissions:** Owner or shared user

**Response 200:** Calendar object

**Response 403:** No access to calendar

**Response 404:** Calendar not found

---

### PUT /calendars/{id}/

Update a calendar. Requires version for optimistic locking.

**Authentication:** Required

**Permissions:** Owner only

**Request Body:**
```json
{
  "name": "Updated Calendar Name",
  "version": 1
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| name | string | Yes | New calendar name |
| version | integer | Yes | Current version number |

**Response 200 (Success):**
```json
{
  "id": "880e8400-e29b-41d4-a716-446655440000",
  "name": "Updated Calendar Name",
  "owner": "550e8400-e29b-41d4-a716-446655440000",
  "sharedWith": [],
  "createdAt": "2026-01-14T10:00:00Z",
  "version": 2
}
```

**Response 409 (Version Conflict):**

Returns the current server state. Client must merge and retry.

```json
{
  "id": "880e8400-e29b-41d4-a716-446655440000",
  "name": "Current Server Name",
  "owner": "550e8400-e29b-41d4-a716-446655440000",
  "sharedWith": [],
  "createdAt": "2026-01-14T10:00:00Z",
  "version": 3
}
```

---

### DELETE /calendars/{id}/

Delete a calendar.

**Authentication:** Required

**Permissions:** Owner only

**Response 204:** No content

**Notes:**
- Cascades to all events in calendar
- Removes sharing relationships

---

### POST /calendars/{id}/share/

Share or unshare a calendar with another user.

**Authentication:** Required

**Permissions:** Owner only

**Request Body:**
```json
{
  "targetUid": "660e8400-e29b-41d4-a716-446655440001",
  "share": true
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| targetUid | UUID | Yes | User to share/unshare with |
| share | boolean | Yes | true=share, false=unshare |

**Response 200:** Updated calendar object

**Notes:**
- Idempotent operation
- Does not increment calendar version

---

## Event Endpoints

### GET /calendars/{calendar_id}/events/

List all events in a calendar.

**Authentication:** Required

**Permissions:** Calendar owner or shared user

**Response 200:**
```json
[
  {
    "id": "990e8400-e29b-41d4-a716-446655440000",
    "name": "Team Meeting",
    "time": "2026-01-15T10:00:00Z",
    "attendees": ["550e8400-e29b-41d4-a716-446655440000"],
    "color": 4294967295,
    "shape": "circle",
    "recurrence": "weekly",
    "recurrenceEndDate": "2026-12-31T23:59:59Z",
    "version": 1
  }
]
```

**Notes:**
- Sorted by `time` ascending (earliest first)

---

### POST /calendars/{calendar_id}/events/

Create a new event.

**Authentication:** Required

**Permissions:** Calendar owner or shared user

**Request Body:**
```json
{
  "name": "Team Meeting",
  "time": "2026-01-15T10:00:00Z",
  "attendees": ["550e8400-e29b-41d4-a716-446655440000"],
  "color": 4278190080,
  "shape": "circle",
  "recurrence": "weekly",
  "recurrenceEndDate": "2026-12-31T23:59:59Z"
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| name | string | Yes | - | Event name (max 200 chars) |
| time | ISO 8601 | Yes | - | Event datetime |
| attendees | UUID[] | No | [] | List of attendee UIDs |
| color | integer | No | 4278190080 | ARGB color (32-bit integer) |
| shape | string | No | "circle" | "circle" or "rectangle" |
| recurrence | string | No | "none" | See recurrence values |
| recurrenceEndDate | ISO 8601 | No* | null | Required if recurrence != "none" |

**Recurrence Values:**
- `none` - No recurrence
- `daily` - Every day
- `weekly` - Every week
- `biweekly` - Every two weeks
- `monthly` - Every month
- `yearly` - Every year

**Response 201:** Created event object

---

### GET /calendars/{calendar_id}/events/{id}/

Get a single event.

**Authentication:** Required

**Permissions:** Calendar owner or shared user

**Response 200:** Event object

---

### PUT /calendars/{calendar_id}/events/{id}/

Update an event. Requires version for optimistic locking.

**Authentication:** Required

**Permissions:** Calendar owner or shared user

**Request Body:**
```json
{
  "name": "Updated Meeting",
  "time": "2026-01-15T14:00:00Z",
  "version": 1
}
```

All fields are optional except `version`. Only specified fields are updated.

**Response 200 (Success):** Updated event with incremented version

**Response 409 (Version Conflict):** Current server state

---

### DELETE /calendars/{calendar_id}/events/{id}/

Delete an event.

**Authentication:** Required

**Permissions:** Calendar owner or shared user

**Response 204:** No content

---

### DELETE /calendars/{calendar_id}/events/clear/

Delete all events in a calendar.

**Authentication:** Required

**Permissions:** Calendar owner or shared user

**Response 200:**
```json
{
  "deleted": 42
}
```

---

## Friend Request Endpoints

### GET /friend-requests/incoming/

Get pending friend requests sent TO current user.

**Authentication:** Required

**Response 200:**
```json
[
  {
    "id": "aa0e8400-e29b-41d4-a716-446655440000",
    "fromUser": "660e8400-e29b-41d4-a716-446655440001",
    "toUser": "550e8400-e29b-41d4-a716-446655440000",
    "status": "pending",
    "createdAt": "2026-01-14T10:00:00Z",
    "expiresAt": "2026-02-13T10:00:00Z",
    "fromDisplayName": "Jane Doe",
    "fromEmail": "jane@example.com",
    "toDisplayName": "John Doe",
    "toEmail": "john@example.com"
  }
]
```

**Notes:**
- Only returns PENDING requests
- Filters out expired requests

---

### GET /friend-requests/sent/

Get pending friend requests sent FROM current user.

**Authentication:** Required

**Response 200:** Array of friend request objects (same format as incoming)

---

### POST /friend-requests/

Send a friend request.

**Authentication:** Required

**Request Body:**
```json
{
  "toUid": "660e8400-e29b-41d4-a716-446655440001"
}
```

**Response 201:** Created friend request object

**Response 400 (Self Request):**
```json
{
  "detail": "Cannot send friend request to yourself."
}
```

**Response 400 (Already Friends):**
```json
{
  "detail": "Already friends with this user."
}
```

**Response 400 (Pending From Other):**
```json
{
  "detail": "This user has already sent you a friend request. Accept it instead."
}
```

**Response 400 (Pending From Self):**
```json
{
  "detail": "Friend request already pending."
}
```

**Notes:**
- Expires in 30 days
- Only one pending request per user pair (either direction)

---

### POST /friend-requests/{id}/accept/

Accept a friend request.

**Authentication:** Required

**Permissions:** Must be recipient (toUser)

**Response 200:** Friend request object with status "accepted"

**Response 400 (Expired):**
```json
{
  "detail": "Friend request has expired."
}
```

**Notes:**
- Adds both users to each other's friends lists
- Atomic transaction

---

### POST /friend-requests/{id}/decline/

Decline a friend request.

**Authentication:** Required

**Permissions:** Must be recipient (toUser)

**Response 200:** Friend request object with status "declined"

---

### DELETE /friend-requests/{id}/

Cancel a sent friend request.

**Authentication:** Required

**Permissions:** Must be sender (fromUser)

**Response 204:** No content

---

## Ownership Transfer Endpoints

### GET /ownership-transfers/incoming/

Get pending ownership transfers TO current user.

**Authentication:** Required

**Response 200:**
```json
[
  {
    "id": "bb0e8400-e29b-41d4-a716-446655440000",
    "calendar": "880e8400-e29b-41d4-a716-446655440000",
    "fromUser": "660e8400-e29b-41d4-a716-446655440001",
    "toUser": "550e8400-e29b-41d4-a716-446655440000",
    "status": "pending",
    "createdAt": "2026-01-14T10:00:00Z",
    "calendarName": "Shared Calendar",
    "fromDisplayName": "Jane Doe",
    "toDisplayName": "John Doe"
  }
]
```

---

### GET /ownership-transfers/sent/

Get pending ownership transfers FROM current user.

**Authentication:** Required

**Response 200:** Array of ownership transfer objects

---

### POST /ownership-transfers/

Request calendar ownership transfer.

**Authentication:** Required

**Permissions:** Must be calendar owner

**Request Body:**
```json
{
  "calendarId": "880e8400-e29b-41d4-a716-446655440000",
  "toUid": "660e8400-e29b-41d4-a716-446655440001"
}
```

**Response 201:** Created transfer request object

**Response 400 (Not Owner):**
```json
{
  "detail": "Only the calendar owner can transfer ownership."
}
```

**Response 400 (Self Transfer):**
```json
{
  "detail": "Cannot transfer ownership to yourself."
}
```

**Response 400 (Pending Transfer):**
```json
{
  "detail": "A transfer request is already pending for this calendar."
}
```

**Notes:**
- Only one pending transfer per calendar allowed

---

### POST /ownership-transfers/{id}/accept/

Accept an ownership transfer.

**Authentication:** Required

**Permissions:** Must be recipient (toUser)

**Response 200:** Transfer object with status "accepted"

**Notes:**
- New owner takes over the calendar
- Old owner becomes shared user
- Atomic transaction

---

### POST /ownership-transfers/{id}/decline/

Decline an ownership transfer.

**Authentication:** Required

**Permissions:** Must be recipient (toUser)

**Response 200:** Transfer object with status "declined"

---

### DELETE /ownership-transfers/{id}/

Cancel a pending transfer request.

**Authentication:** Required

**Permissions:** Must be sender (fromUser)

**Response 204:** No content

---

## Error Handling

### Error Response Format

```json
{
  "detail": "Error message here"
}
```

Or for field validation errors:

```json
{
  "email": ["This field is required."],
  "password": ["Password must be at least 8 characters."]
}
```

### Common Error Scenarios

#### 401 Unauthorized
```json
{
  "detail": "Invalid credentials"
}
```
**Action:** Re-authenticate or check API key validity

#### 403 Forbidden - Email Not Verified
```json
{
  "detail": "Email not verified. Please check your email for the verification link.",
  "emailNotVerified": true
}
```
**Action:** Prompt user to verify email or resend verification

#### 403 Forbidden - Permission Denied
```json
{
  "detail": "You do not have permission to perform this action."
}
```
**Action:** Check if user has required permissions (e.g., calendar owner)

#### 409 Conflict - Version Mismatch
```json
{
  "id": "uuid",
  "name": "Current Name",
  "version": 5,
  "...": "rest of current state"
}
```
**Action:** Merge local changes with returned server state, retry with new version

#### 429 Too Many Requests
```json
{
  "detail": "Request was throttled. Expected available in 60 seconds."
}
```
**Action:** Implement exponential backoff, wait before retrying

---

## Version Conflict Resolution

Calendars and events use **optimistic locking** to handle concurrent modifications.

### How It Works

1. Client fetches resource (includes `version` field)
2. Client sends update with current `version`
3. Server compares versions:
   - **Match:** Update succeeds, version incremented
   - **Mismatch:** Returns 409 with current server state

### Client Implementation

```
1. Attempt update with local version
2. If 409 returned:
   a. Compare server state with local state
   b. Merge changes (handle conflicts as needed)
   c. Retry with new version from server
3. If 200 returned:
   a. Update local state with response
```

### Example Flow

```
Client A: GET /calendars/123/ -> version: 1
Client B: GET /calendars/123/ -> version: 1

Client A: PUT /calendars/123/ {name: "A's Name", version: 1} -> 200, version: 2
Client B: PUT /calendars/123/ {name: "B's Name", version: 1} -> 409, current state with version: 2

Client B: (merges changes, retries)
Client B: PUT /calendars/123/ {name: "B's Name", version: 2} -> 200, version: 3
```

---

## Data Types Reference

### UUID Format
All IDs use UUID v4 format:
```
550e8400-e29b-41d4-a716-446655440000
```

### DateTime Format
ISO 8601 with timezone:
```
2026-01-14T10:00:00Z
```

### Color Format
32-bit ARGB integer:
- Alpha: bits 24-31
- Red: bits 16-23
- Green: bits 8-15
- Blue: bits 0-7

Examples:
- `4278190080` = Opaque black (0xFF000000)
- `4294967295` = Opaque white (0xFFFFFFFF)
- `4294901760` = Opaque red (0xFFFF0000)

### Event Shape
- `"circle"` - Circular event marker
- `"rectangle"` - Rectangular event marker

### Recurrence
- `"none"` - No recurrence
- `"daily"` - Every day
- `"weekly"` - Every 7 days
- `"biweekly"` - Every 14 days
- `"monthly"` - Same day each month
- `"yearly"` - Same date each year

### Friend Request Status
- `"pending"` - Awaiting response
- `"accepted"` - Request accepted
- `"declined"` - Request declined

### Ownership Transfer Status
- `"pending"` - Awaiting response
- `"accepted"` - Transfer completed
- `"declined"` - Transfer rejected
- `"cancelled"` - Sender cancelled

---

## Additional API Endpoints

### GET /api/v1/

API root endpoint.

**Authentication:** None

**Response 200:**
```json
{
  "version": "v1"
}
```

### GET /api/v1/health/

Health check endpoint for monitoring.

**Authentication:** None

**Response 200:**
```json
{
  "status": "healthy"
}
```
