// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/providers/cal/calendar_stream_providers.dart';
import 'package:timeshare/services/logging/app_logger.dart';

// ============================================================================
// OPTIMISTIC STATE
// ============================================================================

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

// ============================================================================
// OPTIMISTIC CALENDARS
// ============================================================================

/// Pending calendar operations for optimistic UI updates.
/// Tracks calendars being added/deleted before server confirmation.
class OptimisticCalendars extends Notifier<OptimisticState<Calendar>> {
  @override
  OptimisticState<Calendar> build() {
    ref.keepAlive();
    return const OptimisticState();
  }

  void addPending(Calendar calendar) {
    state = state.copyWith(pending: [...state.pending, calendar]);
  }

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

final optimisticCalendarsProvider =
    NotifierProvider<OptimisticCalendars, OptimisticState<Calendar>>(
  OptimisticCalendars.new,
);

// ============================================================================
// OPTIMISTIC EVENTS
// ============================================================================

/// Pending event operations for optimistic UI updates.
class OptimisticEvents extends Notifier<OptimisticState<Event>> {
  static const _tag = 'OptimisticEvents';

  @override
  OptimisticState<Event> build() {
    ref.keepAlive();
    AppLogger().warning('build() called', tag: _tag);
    return const OptimisticState();
  }

  void addPending(Event event) {
    AppLogger().warning('addPending: ${event.name} (id: ${event.id})', tag: _tag);
    state = state.copyWith(pending: [...state.pending, event]);
    AppLogger().warning('pending count after add: ${state.pending.length}', tag: _tag);
  }

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

final optimisticEventsProvider =
    NotifierProvider<OptimisticEvents, OptimisticState<Event>>(
  OptimisticEvents.new,
);

// ============================================================================
// CALENDARS WITH OPTIMISTIC
// ============================================================================

/// Calendars with optimistic updates merged in.
/// Use this instead of calendarsProvider for UI that should show optimistic state.
final calendarsWithOptimisticProvider = Provider<AsyncValue<List<Calendar>>>((ref) {
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
});
