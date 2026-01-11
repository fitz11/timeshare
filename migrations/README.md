# Firestore Migrations

This directory contains migration scripts for updating Firestore database schemas.

## Prerequisites

1. **Node.js** (v18 or higher)
2. **Firebase CLI** installed and authenticated

## Setup

```bash
cd migrations
npm install
```

## Authentication

You need Google Cloud credentials to run migrations. Choose one method:

### Option A: Service Account Key (Recommended)

1. Go to [Firebase Console → Project Settings → Service Accounts](https://console.firebase.google.com/project/timeshare-32d37/settings/serviceaccounts/adminsdk)
2. Click "Generate new private key"
3. Save the file as `migrations/service-account.json`
4. Run migrations with:
   ```bash
   node migrate.js --key=service-account.json --dry-run
   ```

**Important:** Never commit `service-account.json` to git! It's already in `.gitignore`.

### Option B: Google Cloud CLI

1. Install gcloud CLI: https://cloud.google.com/sdk/docs/install
2. Authenticate:
   ```bash
   gcloud auth application-default login
   ```
3. Run migrations with:
   ```bash
   node migrate.js --project=timeshare-32d37 --dry-run
   ```

## Running Migrations

### Preview changes (recommended first step)

```bash
npm run migrate:dry-run
```

This shows what changes would be made without actually modifying any data.

### Apply migrations

```bash
npm run migrate
```

### Run a specific migration

```bash
node migrate.js --migration=001
```

## Available Migrations

| File | Description |
|------|-------------|
| `_template.js` | Template for creating new migrations (not executed) |
| `001_add_missing_user_fields.js` | Adds missing `joinedAt`, `friends`, `isAdmin` fields to user documents |
| `002_add_missing_calendar_event_fields.js` | Adds missing `sharedWith` to calendars, `color`, `shape`, `recurrence` to events |
| `003_migrate_embedded_events_to_subcollection.js` | Migrates embedded events map to `events` subcollection |

## Creating New Migrations

1. Copy the template:
   ```bash
   cp scripts/_template.js scripts/NNN_description.js
   ```

2. Edit the new file:
   - Update the description comment at the top
   - Modify the migration logic
   - The template includes common patterns you can copy/paste

3. Test with dry-run first:
   ```bash
   node migrate.js --migration=NNN --dry-run
   ```

### Migration Function Signature

```javascript
export default async function migrate(db, { dryRun, FieldValue }) {
  const stats = { scanned: 0, updated: 0, errors: 0 };

  // Your migration logic here

  return stats;
}
```

### Available in `{ dryRun, FieldValue }`:
- `dryRun` - boolean, true if running in preview mode
- `FieldValue` - Firestore FieldValue for operations like:
  - `FieldValue.delete()` - remove a field
  - `FieldValue.serverTimestamp()` - set server timestamp
  - `FieldValue.arrayUnion([...])` - add to array
  - `FieldValue.arrayRemove([...])` - remove from array
  - `FieldValue.increment(n)` - increment number

## Running on Multiple Projects

To run migrations on different Firebase projects (dev, staging, prod):

```bash
# Switch to dev project
firebase use timeshare-dev
npm run migrate

# Switch to staging
firebase use timeshare-staging
npm run migrate

# Switch to production
firebase use timeshare-32d37
npm run migrate
```

## Safety Notes

- Always run `--dry-run` first to preview changes
- Back up your Firestore data before running migrations in production
- Migrations are idempotent - running them multiple times is safe
