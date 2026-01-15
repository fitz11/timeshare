// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/models/event/event_recurrence.dart';
import 'package:timeshare/providers/cal/events_stream_providers.dart';
import 'package:timeshare/providers/cal/optimistic_providers.dart';
import 'package:timeshare/providers/cal/ui_state_providers.dart';
import 'package:timeshare/services/logging/app_logger.dart';

// ============================================================================
// EVENTS WITH OPTIMISTIC
// ============================================================================

/// Events with optimistic updates merged in.
/// Use this instead of eventsForSelectedCalendarsProvider for UI that should show optimistic state.
final eventsWithOptimisticProvider = Provider<AsyncValue<List<Event>>>((ref) {
  const tag = 'EventsWithOptimistic';
  ref.keepAlive();
  final eventsAsync = ref.watch(eventsForSelectedCalendarsProvider);
  final optimistic = ref.watch(optimisticEventsProvider);

  AppLogger().warning(
    'rebuild - pending: ${optimistic.pending.length}, eventsAsync: ${eventsAsync.runtimeType}',
    tag: tag,
  );

  return eventsAsync.when(
    data: (events) {
      // Filter out items being deleted
      var filtered = events.where((e) => !optimistic.deleting.contains(e.id)).toList();

      // Get IDs of pending items (both new and updates)
      final pendingIds = optimistic.pending.map((e) => e.id).toSet();

      // Clean up pending events that now exist in server data
      final serverIds = events.map((e) => e.id).toSet();
      final resolvedPendingIds = pendingIds.intersection(serverIds);
      if (resolvedPendingIds.isNotEmpty) {
        Future.microtask(() {
          for (final id in resolvedPendingIds) {
            ref.read(optimisticEventsProvider.notifier).removePending(id);
          }
          AppLogger().warning(
            'cleaned up ${resolvedPendingIds.length} resolved pending events',
            tag: tag,
          );
        });
      }

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

      final result = [...filtered, ...newPending];
      AppLogger().warning(
        'data: server=${events.length}, filtered=${filtered.length}, newPending=${newPending.length}, total=${result.length}',
        tag: tag,
      );
      return AsyncData(result);
    },
    loading: () {
      AppLogger().warning('loading - showing ${optimistic.pending.length} pending events', tag: tag);
      return optimistic.pending.isNotEmpty
          ? AsyncData(optimistic.pending)
          : const AsyncLoading();
    },
    error: (e, st) => AsyncError(e, st),
  );
});

// ============================================================================
// VISIBLE EVENTS
// ============================================================================

/// Data class for visible events (replaces separate map and list providers).
class VisibleEvents {
  final Map<DateTime, List<Event>> map;
  final List<Event> list;

  const VisibleEvents({required this.map, required this.list});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VisibleEvents) return false;

    if (list.length != other.list.length) return false;
    for (int i = 0; i < list.length; i++) {
      if (list[i] != other.list[i]) return false;
    }

    if (map.keys.length != other.map.keys.length) return false;
    if (!map.keys.toSet().containsAll(other.map.keys)) return false;

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

/// Expanded events map - memoized recurrence expansion.
/// Only recomputes when events actually change, not on filter/day changes.
final expandedEventsMapProvider = Provider<Map<DateTime, List<Event>>>((ref) {
  const tag = 'ExpandedEventsMap';
  ref.keepAlive();
  final eventsAsync = ref.watch(eventsWithOptimisticProvider);
  final events = eventsAsync.value ?? [];
  AppLogger().warning('rebuild - input events: ${events.length}', tag: tag);

  final horizon = DateTime.now().add(const Duration(days: 365));
  final eventMap = <DateTime, List<Event>>{};

  for (final event in events) {
    if (event.recurrence == EventRecurrence.none) {
      final day = normalizeDate(event.time);
      eventMap.update(
        day,
        (existing) => [...existing, event],
        ifAbsent: () => [event],
      );
    } else {
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
});

/// Consolidated visible events - uses memoized expanded map.
/// Filtering is O(n), not O(n × 365) on day/filter changes.
final visibleEventsProvider = Provider<VisibleEvents>((ref) {
  ref.keepAlive();
  final eventMap = ref.watch(expandedEventsMapProvider);
  final selectedDay = ref.watch(selectedDayProvider);
  final afterToday = ref.watch(afterTodayFilterProvider);
  return _filterVisibleEvents(eventMap, selectedDay, afterToday);
});

VisibleEvents _filterVisibleEvents(
  Map<DateTime, List<Event>> eventMap,
  DateTime? selectedDay,
  bool afterToday,
) {
  // Use normalizeDate for UTC consistency with event map keys
  final today = normalizeDate(DateTime.now());
  Map<DateTime, List<Event>> filteredMap;
  List<Event> eventList;

  if (selectedDay != null) {
    final events = eventMap[selectedDay] ?? [];
    filteredMap = events.isEmpty ? {} : {selectedDay: events};
    eventList = events;
  } else if (afterToday) {
    filteredMap = Map.fromEntries(
      eventMap.entries.where((e) =>
          e.key.isAfter(today) || e.key.isAtSameMomentAs(today)),
    );
    eventList = filteredMap.values.expand((list) => list).toList();
    eventList.sort((a, b) => a.time.compareTo(b.time));
  } else {
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
        final nextMonth = DateTime(current.year, current.month + 1, 1);
        final lastDayOfMonth = DateTime(nextMonth.year, nextMonth.month + 1, 0).day;
        final day = current.day > lastDayOfMonth ? lastDayOfMonth : current.day;
        current = DateTime(nextMonth.year, nextMonth.month, day,
            current.hour, current.minute);
      case EventRecurrence.yearly:
        final targetMonth = DateTime(current.year + 1, current.month, 1);
        final lastDayOfMonth = DateTime(targetMonth.year, targetMonth.month + 1, 0).day;
        final day = current.day > lastDayOfMonth ? lastDayOfMonth : current.day;
        current = DateTime(targetMonth.year, targetMonth.month, day,
            current.hour, current.minute);
      case EventRecurrence.none:
        break;
    }
  }

  return occurrences;
}
