# Security Model

This document explains Timeshare's security architecture, what protections are in place, and important limitations users should understand.

## Authentication

Timeshare uses **Firebase Authentication** for user management. This means:

- Your password is handled entirely by Google/Firebase
- Passwords are never stored in Timeshare's database
- Password reset and account recovery are managed through Firebase
- Authentication tokens are securely managed by the Firebase SDK

### Supported Authentication Methods

- Email/password authentication
- Google Sign-In (where configured)

## Data Storage

### Where Your Data Is Stored

All user data is stored in **Firebase Firestore**, a cloud database operated by Google. Data is stored in Google's data centers, primarily in the United States.

### What Data Is Stored

| Data Type | Fields | Purpose |
|-----------|--------|---------|
| **User Profile** | Email, display name, profile photo URL, join date | Account identification and display |
| **Calendars** | Name, owner, shared users list | Calendar organization |
| **Events** | Name, date/time, color, shape, recurrence settings | Event tracking |
| **Friends** | List of friend user IDs | Social features |

### Data Encryption Status

**Important:** Your calendar and event data is stored **unencrypted** in Firestore. This means:

- Data is encrypted in transit (HTTPS/TLS)
- Data is encrypted at rest by Google's infrastructure
- However, data is **not end-to-end encrypted** — it can be read by:
  - Firebase/Google database administrators
  - Anyone with direct Firestore database access
  - The app developer (with appropriate credentials)

**Recommendation:** Do not store highly sensitive personal information (medical appointments, financial details, confidential meetings) in this app.

## Access Control

Timeshare implements access control through **Firestore Security Rules**:

### What Security Rules Protect

- **Calendars**: Only the owner and users in the `sharedWith` list can read calendar data
- **Events**: Only users with access to the parent calendar can read/modify events
- **User Profiles**: Users can read any profile but only modify their own
- **Friends List**: Only you can modify your friends list

### What Security Rules Do NOT Protect

- Data visibility to database administrators
- Data in backups or exports
- Data if security rules are misconfigured
- Metadata about data access patterns

## Data Sharing

Your calendar data is shared only with:

1. **Users you explicitly share with** via the sharing feature
2. **Firebase/Google** as the infrastructure provider
3. **The app developer** for debugging and support purposes

We do not sell or share your data with third parties for advertising or marketing.

## Data Retention & Deletion

- Your data is retained as long as your account exists
- You can delete your account at any time through the app
- Account deletion removes:
  - All calendars you own (and their events)
  - Your user profile
  - Your friends list
  - Your access is removed from shared calendars

## Reporting Security Issues

If you discover a security vulnerability, please report it by:

1. Opening a private issue on the GitHub repository
2. Emailing the maintainer directly

Please do not publicly disclose security vulnerabilities until they have been addressed.

## Third-Party Services

Timeshare uses the following third-party services:

| Service | Purpose | Privacy Policy |
|---------|---------|----------------|
| Firebase Authentication | User login | [Google Privacy Policy](https://policies.google.com/privacy) |
| Firebase Firestore | Data storage | [Google Privacy Policy](https://policies.google.com/privacy) |
| Firebase Crashlytics | Crash reporting | [Google Privacy Policy](https://policies.google.com/privacy) |

## Updates to This Document

This security document may be updated as the app evolves. Significant changes will be noted in release notes.

---

*Last updated: January 2026*
