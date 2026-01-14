# Tracked Logging Calls

This file documents all logging framework calls in the codebase for debugging purposes.

## Logging Framework

**Package:** `logger` (using `Logger` class with PrettyPrinter)
**Main Service:** `lib/services/logging/app_logger.dart`

## Log Methods

- `debug(message, tag:)` - Debug messages (debug mode only)
- `info(message, tag:)` - Info messages (debug mode only)
- `warning(message, tag:)` - Warnings (always logged)
- `error(message, error:, stackTrace:, tag:)` - Errors (always logged)
- `logApiCall(operationName, operation)` - Timed API calls with rate tracking
- `logStreamSubscription(operationName)` - Stream subscription logging

---

## Logging Calls by File

### App Entry Points

**lib/main.dart**
- Line 15: `await AppLogger().initialize()`

**lib/main_mock.dart**
- Line 45: `await AppLogger().initialize()`

**lib/auth_gate.dart**
- Line 40: `_logger.warning('Initializing auth', tag: _tag)`
- Line 49: `_logger.warning('Auth initialized', tag: _tag)`
- Line 66: `_logger.warning('Auth state: $state', tag: _tag)`
- Line 89: `_logger.error('Auth state error', error: error, stackTrace: stack, tag: _tag)`

---

### AppLogger Internal Calls

**lib/services/logging/app_logger.dart**
- Line 46: `debug('AppLogger initialized', tag: 'Logger')`
- Line 120: `debug('$operationName completed in ${elapsed}ms', tag: 'API')`
- Line 125: `warning('Slow API call: $operationName took ${elapsed}ms', tag: 'API')`
- Line 131-136: `error('$operationName failed after ${stopwatch.elapsedMilliseconds}ms', ...)`
- Line 144: `debug('Stream subscribed: $operationName', tag: 'API')`
- Line 158-162: `warning('Excessive API calls: $operationName called ${tracker.callCountInWindow} times in last minute', tag: 'RateLimit')`

---

### Repository Wrappers (Logged Decorators)

**lib/data/repo/logged_calendar_repo.dart**
- Line 22: `_logger.logStreamSubscription('watchAllAvailableCalendars')`
- Line 28-30: `_logger.logApiCall('getAllAvailableCalendars', ...)`
- Line 36-38: `_logger.logApiCall('createCalendar', ...)`
- Line 44-46: `_logger.logApiCall('getCalendarById', ...)`
- Line 52-54: `_logger.logApiCall('shareCalendar', ...)`
- Line 60-62: `_logger.logApiCall('deleteCalendar', ...)`
- Line 68-70: `_logger.logApiCall('updateCalendar', ...)`
- Line 78: `_logger.logStreamSubscription('watchEventsForCalendar')`
- Line 84-85: `_logger.logStreamSubscription('watchEventsForCalendars(${calendarIds.length} calendars)')`
- Line 92-94: `_logger.logApiCall('getEventsForCalendar', ...)`
- Line 100-102: `_logger.logApiCall('addEvent', ...)`
- Line 108-110: `_logger.logApiCall('updateEvent', ...)`
- Line 116-118: `_logger.logApiCall('deleteEvent', ...)`
- Line 124-126: `_logger.logApiCall('deleteAllEventsForCalendar', ...)`

**lib/data/repo/logged_user_repo.dart**
- Line 21-23: `_logger.logApiCall('getCurrentUser', ...)`
- Line 29-31: `_logger.logApiCall('signInOrRegister', ...)`
- Line 37-39: `_logger.logApiCall('getUserById', ...)`
- Line 45: `_logger.warning('searchUsersByEmail called with: "$email"', tag: 'UserRepo')`
- Line 46-48: `_logger.logApiCall('searchUsersByEmail', ...)`
- Line 54-56: `_logger.logApiCall('getFriendsOfUser', ...)`
- Line 62-64: `_logger.logApiCall('addFriend', ...)`
- Line 70-72: `_logger.logApiCall('removeFriend', ...)`
- Line 78-80: `_logger.logApiCall('removeFriendWithCascade', ...)`
- Line 86-88: `_logger.logApiCall('updateDisplayName', ...)`
- Line 94-96: `_logger.logApiCall('deleteUserAccount', ...)`

**lib/data/repo/logged_friend_request_repo.dart**
- Line 18-20: `_logger.logApiCall('getIncomingRequests', ...)`
- Line 26-28: `_logger.logApiCall('getSentRequests', ...)`
- Line 34-36: `_logger.logApiCall('sendFriendRequest', ...)`
- Line 42-44: `_logger.logApiCall('acceptFriendRequest', ...)`
- Line 50-52: `_logger.logApiCall('declineFriendRequest', ...)`
- Line 58-60: `_logger.logApiCall('cancelFriendRequest', ...)`
- Line 66: `_logger.logStreamSubscription('watchIncomingFriendRequests')`

**lib/data/repo/logged_ownership_transfer_repo.dart**
- Line 18-20: `_logger.logApiCall('getIncomingTransfers', ...)`
- Line 26-28: `_logger.logApiCall('getSentTransfers', ...)`
- Line 37-39: `_logger.logApiCall('requestOwnershipTransfer', ...)`
- Line 45-47: `_logger.logApiCall('acceptOwnershipTransfer', ...)`
- Line 53-55: `_logger.logApiCall('declineOwnershipTransfer', ...)`
- Line 61-63: `_logger.logApiCall('cancelOwnershipTransfer', ...)`
- Line 69: `_logger.logStreamSubscription('watchIncomingOwnershipTransfers')`

---

### Providers

**lib/providers/auth/auth_providers.dart**
- Line 16: `_logger.warning('Creating auth service for ${config.apiBaseUrl}', tag: _tag)`

**lib/providers/user/user_providers.dart**
- Line 119: `AppLogger().warning('skipped - query too short: "$trimmed" (${trimmed.length} chars)', tag: tag)`
- Line 123: `AppLogger().warning('searching for: "$trimmed"', tag: tag)`
- Line 125: `AppLogger().warning('found ${results.length} results for: "$trimmed"', tag: tag)`

**lib/providers/cal/optimistic_providers.dart**
- Line 88: `AppLogger().warning('build() called', tag: _tag)`
- Line 93: `AppLogger().warning('addPending: ${event.name} (id: ${event.id})', tag: _tag)`
- Line 95: `AppLogger().warning('pending count after add: ${state.pending.length}', tag: _tag)`

**lib/providers/cal/events_providers.dart**
- Line 24-26: `AppLogger().warning('rebuild - pending: ${optimistic.pending.length}, eventsAsync: ${eventsAsync.runtimeType}', tag: tag)`
- Line 45-47: `AppLogger().warning('cleaned up ${resolvedPendingIds.length} resolved pending events', tag: tag)`
- Line 65-67: `AppLogger().warning('data: server=${events.length}, filtered=${filtered.length}, newPending=${newPending.length}, total=${result.length}', tag: tag)`
- Line 72: `AppLogger().warning('loading - showing ${optimistic.pending.length} pending events', tag: tag)`
- Line 131: `AppLogger().warning('rebuild - input events: ${events.length}', tag: tag)`

---

### UI Components

**lib/ui/features/calendar/calendar_page.dart**
- Line 77: `_logger.error('Failed to load calendars', error: error, stackTrace: stack, tag: _tag)`

**lib/ui/features/calendar/dialogs/edit_event_dialog.dart**
- Line 130: `_logger.info('Updating event: ${updatedEvent.name}', tag: _tag)`
- Line 151: `_logger.error('Failed to update event', error: error, tag: _tag)`
- Line 166: `_logger.info('Deleting event: ${widget.event.name}', tag: _tag)`
- Line 180: `_logger.error('Failed to delete event', error: result.error, tag: _tag)`

**lib/ui/features/calendar/dialogs/create_event_dialog.dart**
- Line 117: `_logger.info('Creating event: ${newEvent.name}', tag: _tag)`
- Line 128: `_logger.error('Failed to create event', error: result.error, tag: _tag)`

---

## Summary

| Category | Count |
|----------|-------|
| `debug()` | 3 |
| `info()` | 3 |
| `warning()` | 14 |
| `error()` | 6 |
| `logApiCall()` | 22 |
| `logStreamSubscription()` | 6 |
| **Total** | **54** |
