// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';
import 'package:timeshare/data/exceptions/conflict_exception.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/models/event/event_recurrence.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/data/repo/rest_api_repo.dart';
import 'package:timeshare/data/repo/logged_calendar_repo.dart';
import 'package:timeshare/data/services/api_client.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/config/config_providers.dart';
import 'package:timeshare/services/logging/app_logger.dart';

part 'cal_providers.g.dart';

const _uuid = Uuid();

/// AppLogger provider - enables DI and easier testing
@riverpod
AppLogger appLogger(Ref ref) => AppLogger();

/// Repository provider with logging wrapper - uses REST API
@riverpod
CalendarRepository calendarRepository(Ref ref) {
  final config = ref.watch(appConfigProvider);
  final authService = ref.watch(authServiceProvider);
  final apiClient = HttpApiClient(
    baseUrl: config.apiBaseUrl,
    getApiKey: () => authService.apiKey,
  );
  return LoggedCalendarRepository(
    RestApiRepository(client: apiClient),
    ref.watch(appLoggerProvider),
  );
}

/// Main calendar stream - automatically updates when Firestore changes
/// Keep alive to prevent re-initialization when navigating away
@riverpod
Stream<List<Calendar>> calendars(Ref ref) {
  ref.keepAlive();
  final repo = ref.watch(calendarRepositoryProvider);
  return repo.watchAllAvailableCalendars();
}

/// Events stream for selected calendars
@riverpod
Stream<List<Event>> eventsForSelectedCalendars(Ref ref) {
  ref.keepAlive();
  final repo = ref.watch(calendarRepositoryProvider);
  final selectedIds = ref.watch(selectedCalendarIdsProvider);

  if (selectedIds.isEmpty) {
    return Stream.value([]);
  }

  return repo.watchEventsForCalendars(selectedIds.toList());
}

/// Result of an optimistic mutation operation.
class MutationResult<T> {
  final T? data;
  final String? error;

  const MutationResult.success(this.data) : error = null;
  const MutationResult.failure(this.error) : data = null;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;
}

/// Calendar mutations with optimistic update support.
/// Includes conflict detection and retry mechanisms for concurrent edit handling.
@riverpod
class CalendarMutations extends _$CalendarMutations {
  /// Helper getter to avoid repetitive ref.read() calls
  CalendarRepository get _repo => ref.read(calendarRepositoryProvider);

  @override
  void build() {
    // No initial state needed
  }

  /// Add calendar with optimistic UI update.
  /// Returns immediately after adding to optimistic state.
  /// The returned Future completes when the server responds.
  Future<MutationResult<Calendar>> addCalendarOptimistic({
    required String ownerUid,
    required String name,
  }) async {
    final calendar = Calendar(
      id: '${ownerUid}_$name', // Temporary ID matching backend pattern
      owner: ownerUid,
      name: name,
    );

    // Add to optimistic state immediately
    ref.read(optimisticCalendarsProvider.notifier).addPending(calendar);
    // Also select it immediately
    ref.read(selectedCalendarIdsProvider.notifier).toggle(calendar.id);

    try {
      await _repo.createCalendar(calendar);
      // Success - remove optimistic and fetch server data immediately
      ref.read(optimisticCalendarsProvider.notifier).removePending(calendar.id);
      ref.invalidate(calendarsProvider);
      return MutationResult.success(calendar);
    } catch (e) {
      // Failure - remove from optimistic and deselect
      ref.read(optimisticCalendarsProvider.notifier).removePending(calendar.id);
      ref.read(selectedCalendarIdsProvider.notifier).toggle(calendar.id);
      return MutationResult.failure('Failed to create calendar: $e');
    }
  }

  /// Add event with optimistic UI update.
  Future<MutationResult<Event>> addEventOptimistic({
    required String calendarId,
    required Event event,
  }) async {
    // Ensure event has an ID
    final eventToAdd = event.id.isEmpty
        ? event.copyWith(id: _uuid.v4())
        : event;

    // Add to optimistic state immediately
    ref.read(optimisticEventsProvider.notifier).addPending(eventToAdd);

    try {
      final created = await _repo.addEvent(calendarId, eventToAdd);
      // Success - remove optimistic and fetch server data immediately
      // (server may assign different ID, so we need to sync)
      ref.read(optimisticEventsProvider.notifier).removePending(eventToAdd.id);
      ref.invalidate(eventsForSelectedCalendarsProvider);
      return MutationResult.success(created);
    } catch (e) {
      // Failure - remove from optimistic
      ref.read(optimisticEventsProvider.notifier).removePending(eventToAdd.id);
      return MutationResult.failure('Failed to create event: $e');
    }
  }

  /// Delete calendar with optimistic UI update.
  Future<MutationResult<void>> deleteCalendarOptimistic(String calendarId) async {
    // Mark as deleting immediately (will be hidden from UI)
    ref.read(optimisticCalendarsProvider.notifier).addDeleting(calendarId);
    // Deselect the calendar
    final wasSelected = ref.read(selectedCalendarIdsProvider).contains(calendarId);
    if (wasSelected) {
      ref.read(selectedCalendarIdsProvider.notifier).toggle(calendarId);
    }

    try {
      await _repo.deleteCalendar(calendarId);
      // Success - remove from deleting set (polling will sync the removal)
      ref.read(optimisticCalendarsProvider.notifier).removeDeleting(calendarId);
      return const MutationResult.success(null);
    } catch (e) {
      // Failure - remove from deleting (calendar still exists)
      ref.read(optimisticCalendarsProvider.notifier).removeDeleting(calendarId);
      // Re-select if it was selected before
      if (wasSelected) {
        ref.read(selectedCalendarIdsProvider.notifier).toggle(calendarId);
      }
      return MutationResult.failure('Failed to delete calendar: $e');
    }
  }

  /// Delete event with optimistic UI update.
  Future<MutationResult<void>> deleteEventOptimistic({
    required String calendarId,
    required String eventId,
  }) async {
    // Mark as deleting immediately (will be hidden from UI)
    ref.read(optimisticEventsProvider.notifier).addDeleting(eventId);

    try {
      await _repo.deleteEvent(calendarId, eventId);
      // Success - remove from deleting set (polling will sync the removal)
      ref.read(optimisticEventsProvider.notifier).removeDeleting(eventId);
      return const MutationResult.success(null);
    } catch (e) {
      // Failure - remove from deleting (event still exists)
      ref.read(optimisticEventsProvider.notifier).removeDeleting(eventId);
      return MutationResult.failure('Failed to delete event: $e');
    }
  }

  // Legacy methods kept for compatibility
  Future<void> addCalendar({
    required String ownerUid,
    required String name,
  }) async {
    final calendar = Calendar(
      id: _uuid.v4(),
      owner: ownerUid,
      name: name,
    );
    await _repo.createCalendar(calendar);
  }

  Future<Event> addEvent({
    required String calendarId,
    required Event event,
  }) async {
    // Ensure event has an ID
    final eventToAdd = event.id.isEmpty
        ? event.copyWith(id: _uuid.v4())
        : event;

    return await _repo.addEvent(calendarId, eventToAdd);
  }

  /// Update event with simple async call (no optimistic update).
  /// Use [updateEventOptimistic] for optimistic UI updates.
  Future<Event> updateEvent({
    required String calendarId,
    required Event event,
  }) =>
      _repo.updateEvent(calendarId, event);

  /// Update event with optimistic update and conflict handling.
  ///
  /// The [onConflict] callback is called when a version conflict is detected,
  /// providing the [ConflictException] with server data for manual resolution.
  ///
  /// Returns the updated event from the server on success.
  /// Throws [ConflictException] if a conflict is detected and not handled.
  Future<Event> updateEventOptimistic({
    required String calendarId,
    required Event event,
    void Function(ConflictException)? onConflict,
  }) async {
    // Optimistically update the event in local state
    ref.read(optimisticEventsProvider.notifier).updatePending(event);

    try {
      final updatedEvent = await _repo.updateEvent(calendarId, event);
      // Success - remove from optimistic (server data will come via polling)
      ref.read(optimisticEventsProvider.notifier).removePending(event.id);
      return updatedEvent;
    } on ConflictException catch (e) {
      // Rollback optimistic update
      ref.read(optimisticEventsProvider.notifier).removePending(event.id);
      // Notify caller of conflict
      onConflict?.call(e);
      // Keep invalidation for conflicts to get fresh server state
      ref.invalidate(eventsForSelectedCalendarsProvider);
      rethrow;
    } catch (e) {
      // Rollback optimistic update on any error
      ref.read(optimisticEventsProvider.notifier).removePending(event.id);
      rethrow;
    }
  }

  /// Retry an event update with server data as the base.
  ///
  /// Use this after receiving a [ConflictException] to retry the update
  /// using the server's current version as the base.
  ///
  /// The [mergeStrategy] function receives the local event and server event
  /// and should return the merged event to save.
  Future<Event> retryEventUpdateWithMerge({
    required String calendarId,
    required Event localEvent,
    required Event serverEvent,
    required Event Function(Event local, Event server) mergeStrategy,
  }) async {
    final mergedEvent = mergeStrategy(localEvent, serverEvent);
    return await _repo.updateEvent(calendarId, mergedEvent);
  }

  /// Update calendar with optimistic update and conflict handling.
  ///
  /// The [onConflict] callback is called when a version conflict is detected.
  Future<Calendar> updateCalendar({
    required Calendar calendar,
    void Function(ConflictException)? onConflict,
  }) async {
    // Optimistically update the calendar in local state
    ref.read(optimisticCalendarsProvider.notifier).updatePending(calendar);

    try {
      final updatedCalendar = await _repo.updateCalendar(calendar);
      // Success - remove from optimistic (server data will come via polling)
      ref.read(optimisticCalendarsProvider.notifier).removePending(calendar.id);
      return updatedCalendar;
    } on ConflictException catch (e) {
      // Rollback optimistic update
      ref.read(optimisticCalendarsProvider.notifier).removePending(calendar.id);
      onConflict?.call(e);
      // Keep invalidation for conflicts to get fresh server state
      ref.invalidate(calendarsProvider);
      rethrow;
    } catch (e) {
      // Rollback optimistic update on any error
      ref.read(optimisticCalendarsProvider.notifier).removePending(calendar.id);
      rethrow;
    }
  }

  Future<void> deleteEvent({
    required String calendarId,
    required String eventId,
  }) =>
      _repo.deleteEvent(calendarId, eventId);

  Future<void> deleteCalendar(String calendarId) =>
      _repo.deleteCalendar(calendarId);

  Future<void> shareCalendar(
    String calendarId,
    String targetUid,
    bool share,
  ) =>
      _repo.shareCalendar(calendarId, targetUid, share);
}

/// Selected calendar IDs - which calendars are visible
/// Synchronous projection from calendars stream - no async overhead.
@riverpod
class SelectedCalendarIds extends _$SelectedCalendarIds {
  @override
  Set<String> build() {
    // Project calendar IDs synchronously from the stream value
    final calendarsAsync = ref.watch(calendarsProvider);
    final calendars = calendarsAsync.value ?? [];
    return calendars.map((c) => c.id).toSet();
  }

  void toggle(String id) {
    if (state.contains(id)) {
      state = state.where((e) => e != id).toSet();
    } else {
      state = {...state, id};
    }
  }

  void selectAll() {
    final calendars = ref.watch(calendarsProvider).value ?? [];
    state = calendars.map((cal) => cal.id).toSet();
  }

  void clear() => state = {};
}

/// Selected day in the calendar
@riverpod
class SelectedDay extends _$SelectedDay {
  @override
  DateTime? build() => null;

  void select(DateTime day) => state = normalizeDate(day);
  void clear() => state = null;
}

/// Focused day in the calendar widget (which month is displayed)
@riverpod
class FocusedDay extends _$FocusedDay {
  @override
  DateTime build() => normalizeDate(DateTime.now());

  void set(DateTime day) => state = normalizeDate(day);
}

/// Calendar display format (month, two weeks, week)
@riverpod
class CalendarFormatState extends _$CalendarFormatState {
  @override
  CalendarFormat build() => CalendarFormat.month;

  void set(CalendarFormat format) => state = format;
}

/// Filter toggle - show only events after today
@riverpod
class AfterTodayFilter extends _$AfterTodayFilter {
  @override
  bool build() => true;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}

/// Interaction mode (normal, copy, delete)
@riverpod
class InteractionModeState extends _$InteractionModeState {
  @override
  InteractionMode build() => InteractionMode.normal;

  void setMode(InteractionMode mode) => state = mode;
  void setNormal() => state = InteractionMode.normal;
  void setCopy() => state = InteractionMode.copy;
  void setDelete() => state = InteractionMode.delete;
}

/// Event being copied (when in copy mode)
@riverpod
class CopyEventState extends _$CopyEventState {
  @override
  Event? build() {
    // Keep alive to prevent disposal when EventListItem is removed from tree
    ref.keepAlive();
    return null;
  }

  void set(Event event) {
    state = event.copyWith();
  }

  void clear() {
    state = null;
  }
}

/// Expanded events map - memoized recurrence expansion.
/// Only recomputes when events actually change, not on filter/day changes.
/// Uses optimistic events for instant UI feedback.
@riverpod
Map<DateTime, List<Event>> expandedEventsMap(Ref ref) {
  ref.keepAlive();
  final eventsAsync = ref.watch(eventsWithOptimisticProvider);
  final events = eventsAsync.value ?? [];

  final horizon = DateTime.now().add(const Duration(days: 365)); // 1 year horizon
  final eventMap = <DateTime, List<Event>>{};

  for (final event in events) {
    if (event.recurrence == EventRecurrence.none) {
      // Non-recurring: add to its date
      final day = normalizeDate(event.time);
      eventMap.update(
        day,
        (existing) => [...existing, event],
        ifAbsent: () => [event],
      );
    } else {
      // Recurring: expand occurrences
      final occurrences = _expandRecurrence(event, horizon);
      for (final occurrence in occurrences) {
        final day = normalizeDate(occurrence.time);
        eventMap.update(
          day,
          (existing) => [...existing, occurrence],
          ifAbsent: () => [occurrence],
        );
      }
    }
  }

  return eventMap;
}

/// Consolidated visible events - uses memoized expanded map.
/// Filtering is O(n), not O(n × 365) on day/filter changes.
@riverpod
VisibleEvents visibleEvents(Ref ref) {
  ref.keepAlive();
  final eventMap = ref.watch(expandedEventsMapProvider);
  final selectedDay = ref.watch(selectedDayProvider);
  final afterToday = ref.watch(afterTodayFilterProvider);
  return _filterVisibleEvents(eventMap, selectedDay, afterToday);
}

VisibleEvents _filterVisibleEvents(
  Map<DateTime, List<Event>> eventMap,
  DateTime? selectedDay,
  bool afterToday,
) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  Map<DateTime, List<Event>> filteredMap;
  List<Event> eventList;

  if (selectedDay != null) {
    // Single day selected - return only that day's events
    final events = eventMap[selectedDay] ?? [];
    filteredMap = events.isEmpty ? {} : {selectedDay: events};
    eventList = events;
  } else if (afterToday) {
    // Filter to dates >= today
    filteredMap = Map.fromEntries(
      eventMap.entries.where((e) =>
          e.key.isAfter(today) || e.key.isAtSameMomentAs(today)),
    );
    eventList = filteredMap.values.expand((list) => list).toList();
    eventList.sort((a, b) => a.time.compareTo(b.time));
  } else {
    // No filter - return all
    filteredMap = eventMap;
    eventList = eventMap.values.expand((list) => list).toList();
    eventList.sort((a, b) => a.time.compareTo(b.time));
  }

  return VisibleEvents(map: filteredMap, list: eventList);
}

/// Expand a recurring event into individual occurrences.
List<Event> _expandRecurrence(Event event, DateTime horizon) {
  final occurrences = <Event>[];
  final endDate = event.recurrenceEndDate ?? horizon;
  final limit = endDate.isBefore(horizon) ? endDate : horizon;

  var current = event.time;

  while (!current.isAfter(limit)) {
    occurrences.add(event.copyWith(time: current));

    switch (event.recurrence) {
      case EventRecurrence.daily:
        current = current.add(const Duration(days: 1));
      case EventRecurrence.weekly:
        current = current.add(const Duration(days: 7));
      case EventRecurrence.monthly:
        current = DateTime(current.year, current.month + 1, current.day,
            current.hour, current.minute);
      case EventRecurrence.yearly:
        current = DateTime(current.year + 1, current.month, current.day,
            current.hour, current.minute);
      case EventRecurrence.none:
        break; // Should not happen
    }
  }

  return occurrences;
}

/// Data class for visible events (replaces separate map and list providers)
class VisibleEvents {
  final Map<DateTime, List<Event>> map;
  final List<Event> list;

  const VisibleEvents({required this.map, required this.list});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VisibleEvents) return false;

    // Compare lists (events have Freezed equality)
    if (list.length != other.list.length) return false;
    for (int i = 0; i < list.length; i++) {
      if (list[i] != other.list[i]) return false;
    }

    // Compare map keys
    if (map.keys.length != other.map.keys.length) return false;
    if (!map.keys.toSet().containsAll(other.map.keys)) return false;

    // Compare map values
    for (final key in map.keys) {
      final thisList = map[key]!;
      final otherList = other.map[key]!;
      if (thisList.length != otherList.length) return false;
      for (int i = 0; i < thisList.length; i++) {
        if (thisList[i] != otherList[i]) return false;
      }
    }

    return true;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(list),
        Object.hashAll(map.keys),
      );
}

/// Calendar name lookup by ID - prevents full calendar list watches in EventListItem.
/// Uses family modifier so each calendar ID gets its own cached provider instance.
@riverpod
String calendarName(Ref ref, String calendarId) {
  final calendars = ref.watch(calendarsProvider).value ?? [];
  try {
    return calendars.firstWhere((c) => c.id == calendarId).name;
  } catch (_) {
    return 'Unknown Calendar';
  }
}

/// Map of calendar IDs to names - for efficient bulk lookups in lists.
@riverpod
Map<String, String> calendarNamesMap(Ref ref) {
  final calendars = ref.watch(calendarsProvider).value ?? [];
  return {for (final c in calendars) c.id: c.name};
}

/// Look up source event by ID (non-expanded, original recurrence start time).
/// Used by EditEventDialog to get the true source event rather than an expanded occurrence.
@riverpod
Event? sourceEvent(Ref ref, String eventId) {
  final events = ref.watch(eventsWithOptimisticProvider).value ?? [];
  try {
    return events.firstWhere((e) => e.id == eventId);
  } catch (_) {
    return null;
  }
}

// ============================================================================
// OPTIMISTIC UI STATE
// ============================================================================

/// Pending calendar operations for optimistic UI updates.
/// Tracks calendars being added/deleted before server confirmation.
@riverpod
class OptimisticCalendars extends _$OptimisticCalendars {
  @override
  OptimisticState<Calendar> build() => const OptimisticState();

  void addPending(Calendar calendar) {
    state = state.copyWith(pending: [...state.pending, calendar]);
  }

  /// Update an existing calendar optimistically (for edit operations).
  /// Replaces any existing pending calendar with the same ID.
  void updatePending(Calendar calendar) {
    state = state.copyWith(
      pending: [...state.pending.where((c) => c.id != calendar.id), calendar],
    );
  }

  void removePending(String id) {
    state = state.copyWith(
      pending: state.pending.where((c) => c.id != id).toList(),
    );
  }

  void addDeleting(String id) {
    state = state.copyWith(deleting: {...state.deleting, id});
  }

  void removeDeleting(String id) {
    state = state.copyWith(deleting: state.deleting.where((i) => i != id).toSet());
  }
}

/// Pending event operations for optimistic UI updates.
@riverpod
class OptimisticEvents extends _$OptimisticEvents {
  @override
  OptimisticState<Event> build() => const OptimisticState();

  void addPending(Event event) {
    state = state.copyWith(pending: [...state.pending, event]);
  }

  /// Update an existing event optimistically (for edit operations).
  /// Replaces any existing pending event with the same ID.
  void updatePending(Event event) {
    state = state.copyWith(
      pending: [...state.pending.where((e) => e.id != event.id), event],
    );
  }

  void removePending(String id) {
    state = state.copyWith(
      pending: state.pending.where((e) => e.id != id).toList(),
    );
  }

  void addDeleting(String id) {
    state = state.copyWith(deleting: {...state.deleting, id});
  }

  void removeDeleting(String id) {
    state = state.copyWith(deleting: state.deleting.where((i) => i != id).toSet());
  }
}

/// Generic state for optimistic updates.
class OptimisticState<T> {
  final List<T> pending;
  final Set<String> deleting;

  const OptimisticState({
    this.pending = const [],
    this.deleting = const {},
  });

  OptimisticState<T> copyWith({
    List<T>? pending,
    Set<String>? deleting,
  }) {
    return OptimisticState(
      pending: pending ?? this.pending,
      deleting: deleting ?? this.deleting,
    );
  }
}

/// Calendars with optimistic updates merged in.
/// Use this instead of calendarsProvider for UI that should show optimistic state.
@riverpod
AsyncValue<List<Calendar>> calendarsWithOptimistic(Ref ref) {
  final calendarsAsync = ref.watch(calendarsProvider);
  final optimistic = ref.watch(optimisticCalendarsProvider);

  return calendarsAsync.when(
    data: (calendars) {
      // Filter out items being deleted
      var filtered = calendars.where((c) => !optimistic.deleting.contains(c.id)).toList();

      // Get IDs of pending items (both new and updates)
      final pendingIds = optimistic.pending.map((c) => c.id).toSet();

      // Replace calendars that have pending updates
      filtered = filtered.map((c) {
        if (pendingIds.contains(c.id)) {
          return optimistic.pending.firstWhere((p) => p.id == c.id);
        }
        return c;
      }).toList();

      // Add truly new pending items (not updates to existing calendars)
      final existingIds = filtered.map((c) => c.id).toSet();
      final newPending = optimistic.pending.where((c) => !existingIds.contains(c.id));

      return AsyncData([...filtered, ...newPending]);
    },
    loading: () => optimistic.pending.isNotEmpty
        ? AsyncData(optimistic.pending)
        : const AsyncLoading(),
    error: (e, st) => AsyncError(e, st),
  );
}

/// Events with optimistic updates merged in.
/// Use this instead of eventsForSelectedCalendarsProvider for UI that should show optimistic state.
@riverpod
AsyncValue<List<Event>> eventsWithOptimistic(Ref ref) {
  final eventsAsync = ref.watch(eventsForSelectedCalendarsProvider);
  final optimistic = ref.watch(optimisticEventsProvider);

  return eventsAsync.when(
    data: (events) {
      // Filter out items being deleted
      var filtered = events.where((e) => !optimistic.deleting.contains(e.id)).toList();

      // Get IDs of pending items (both new and updates)
      final pendingIds = optimistic.pending.map((e) => e.id).toSet();

      // Replace events that have pending updates
      filtered = filtered.map((e) {
        if (pendingIds.contains(e.id)) {
          return optimistic.pending.firstWhere((p) => p.id == e.id);
        }
        return e;
      }).toList();

      // Add truly new pending items (not updates to existing events)
      final existingIds = filtered.map((e) => e.id).toSet();
      final newPending = optimistic.pending.where((e) => !existingIds.contains(e.id));

      return AsyncData([...filtered, ...newPending]);
    },
    loading: () => optimistic.pending.isNotEmpty
        ? AsyncData(optimistic.pending)
        : const AsyncLoading(),
    error: (e, st) => AsyncError(e, st),
  );
}
