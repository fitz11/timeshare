// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/models/event/event_recurrence.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/data/repo/firebase_repo.dart';

part 'cal_providers.g.dart';

/// Repository provider
@riverpod
CalendarRepository calendarRepository(Ref ref) => FirebaseRepository();

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

/// Calendar mutations - simplified without optimistic updates.
/// The stream will automatically update the UI when Firestore changes.
@riverpod
class CalendarMutations extends _$CalendarMutations {
  /// Helper getter to avoid repetitive ref.read() calls
  CalendarRepository get _repo => ref.read(calendarRepositoryProvider);

  @override
  void build() {
    // No initial state needed
  }

  Future<void> addCalendar({
    required String ownerUid,
    required String name,
  }) async {
    final calendar = Calendar(
      id: '${ownerUid}_$name',
      owner: ownerUid,
      name: name,
    );
    await _repo.createCalendar(calendar);
  }

  Future<void> addEvent({
    required String calendarId,
    required Event event,
  }) async {
    // Ensure event has an ID
    final eventToAdd = event.id.isEmpty
        ? event.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString())
        : event;

    await _repo.addEvent(calendarId, eventToAdd);
  }

  Future<void> updateEvent({
    required String calendarId,
    required Event event,
  }) =>
      _repo.updateEvent(calendarId, event);

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
    final calendars = ref.watch(calendarsProvider).value ?? [];
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
  Event? build() => null;

  void set(Event event) => state = event.copyWith();
  void clear() => state = null;
}

/// Expanded events map - memoized recurrence expansion.
/// Only recomputes when events actually change, not on filter/day changes.
@riverpod
Map<DateTime, List<Event>> expandedEventsMap(Ref ref) {
  ref.keepAlive();
  final eventsAsync = ref.watch(eventsForSelectedCalendarsProvider);
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
  List<Event> eventList;

  if (selectedDay != null) {
    eventList = eventMap[selectedDay] ?? [];
  } else {
    eventList = eventMap.values.expand((list) => list).toList();
    eventList.sort((a, b) => a.time.compareTo(b.time));

    if (afterToday) {
      eventList = eventList.where((e) => e.time.isAfter(now)).toList();
    }
  }

  return VisibleEvents(map: eventMap, list: eventList);
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
}
