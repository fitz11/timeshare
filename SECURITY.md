# Security Model

This document explains Timeshare's security architecture, what protections are in place, and important limitations users should understand.

## Authentication

Timeshare uses **API key authentication** via a REST API backend. This means:

- Your password is hashed and stored securely on the server
- API keys are generated upon login and stored securely on your device
- Password reset and account recovery are managed through the API

### Supported Authentication Methods

- Email/password authentication

## Data Storage

### Where Your Data Is Stored

All user data is stored in a **REST API backend** database. Data is transmitted securely via HTTPS.

### What Data Is Stored

| Data Type | Fields | Purpose |
|-----------|--------|---------|
| **User Profile** | Email, display name, profile photo URL, join date | Account identification and display |
| **Calendars** | Name, owner, shared users list, version | Calendar organization |
| **Events** | Name, date/time, color, shape, recurrence settings, version | Event tracking |
| **Friends** | List of friend user IDs | Social features |
| **Friend Requests** | Sender, receiver, status, expiration (30 days) | Friend request management |
| **Ownership Transfers** | Calendar, sender, receiver, status | Calendar ownership transfer |

### Data Encryption Status

**Important:** Your calendar and event data is **not end-to-end encrypted**. This means:

- Data is encrypted in transit (HTTPS/TLS)
- Data is encrypted at rest by the server infrastructure
- However, data **can be read by** database administrators

**Recommendation:** Do not store highly sensitive personal information (medical appointments, financial details, confidential meetings) in this app.

## Access Control

Timeshare implements access control through **server-side authorization**:

### What Access Control Protects

- **Calendars**: Only the owner and users in the `sharedWith` list can read calendar data
- **Events**: Only users with access to the parent calendar can read/modify events
- **User Profiles**: Users can read any profile but only modify their own
- **Friends List**: Only you can modify your friends list
- **Conflict Detection**: Version fields prevent concurrent edit conflicts

### What Access Control Does NOT Protect

- Data visibility to database administrators
- Data in backups or exports
- Metadata about data access patterns

## Data Sharing

Your calendar data is shared only with:

1. **Users you explicitly share with** via the sharing feature
2. **The backend infrastructure provider** for data storage
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

| Service | Purpose |
|---------|---------|
| REST API Backend | Data storage and authentication |

## Updates to This Document

This security document may be updated as the app evolves. Significant changes will be noted in release notes.

---

*Last updated: January 2026*
