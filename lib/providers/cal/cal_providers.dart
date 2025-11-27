import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';
import 'package:timeshare/data/enums.dart';

part 'cal_providers.g.dart';

/// Repository provider
@riverpod
CalendarRepository calendarRepository(Ref ref) => CalendarRepository();

/// Main calendar stream - automatically updates when Firestore changes
/// Keep alive to prevent re-initialization when navigating away
@riverpod
Stream<List<Calendar>> calendars(Ref ref) {
  ref.keepAlive();
  final repo = ref.watch(calendarRepositoryProvider);
  return repo.watchAllAvailableCalendars();
}

/// Calendar mutations - simplified without optimistic updates
/// The stream will automatically update the UI when Firestore changes
@riverpod
class CalendarMutations extends _$CalendarMutations {
  @override
  FutureOr<void> build() {
    // No initial state needed
  }

  Future<void> addCalendar({
    required String ownerUid,
    required String name,
  }) async {
    final repo = ref.read(calendarRepositoryProvider);
    final calendar = Calendar(
      id: '${ownerUid}_$name',
      owner: ownerUid,
      name: name,
      events: <DateTime, List<Event>>{},
    );
    await repo.addCalendar(calendar);
    // Stream will automatically update, no need to manually update state
  }

  Future<void> addEventToCalendar({
    required String calendarId,
    required Event event,
  }) async {
    final repo = ref.read(calendarRepositoryProvider);

    // Section to check if calendar already has given event
    final calendarToAdd = ref
        .read(calendarsProvider)
        .value
        ?.firstWhere((cal) => cal.id == calendarId);
    // Break if no calendar to add to (Maybe provider doesn't have the value)
    if (calendarToAdd == null) {
      print('null calendarToAdd');
      return;
    }
    final calendarEvents = calendarToAdd.events[event.time] ?? [];
    if (!calendarEvents.contains(event)) {
      await repo.addEventToCalendar(calendarId: calendarId, event: event);
      return;
    }
    print('duplicate event noted');
  }

  Future<void> removeEvent({
    required String calendarId,
    required Event event,
  }) async {
    final repo = ref.read(calendarRepositoryProvider);
    await repo.removeEventFromCalendar(calendarId: calendarId, event: event);
  }

  Future<void> shareCalendar(
    String calendarId,
    String targetUid,
    bool share,
  ) async {
    final repo = ref.read(calendarRepositoryProvider);
    await repo.shareCalendar(calendarId, targetUid, share);
    // Stream will automatically update
  }
}

/// Selected calendar IDs - which calendars are visible
@riverpod
class SelectedCalendarIds extends _$SelectedCalendarIds {
  @override
  FutureOr<Set<String>> build() {
    return ref.watch(
      calendarsProvider.selectAsync((cal) => cal.map((c) => c.id).toSet()),
    );
  }

  void toggle(String id) {
    final current = state.requireValue;
    if (current.contains(id)) {
      state = AsyncValue.data(current.where((e) => e != id).toSet());
    } else {
      state = AsyncValue.data({...current, id});
    }
  }

  void selectAll() {
    final calendarsAsync = ref.watch(calendarsProvider);
    calendarsAsync.when(
      data: (calendars) {
        state = AsyncValue.data(calendars.map((cal) => cal.id).toSet());
      },
      loading: () {},
      error: (_, _) {},
    );
  }

  void clear() => state = AsyncValue.data({});
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

/// Consolidated visible events - combines all selected calendars
/// This replaces both visibleEventsMapProvider and visibleEventsListProvider
@riverpod
VisibleEvents visibleEvents(Ref ref) {
  ref.keepAlive();
  final calendarsAsync = ref.watch(calendarsProvider);
  final selectedIds = ref.watch(selectedCalendarIdsProvider);
  final selectedDay = ref.watch(selectedDayProvider);
  final afterToday = ref.watch(afterTodayFilterProvider);

  return calendarsAsync.when(
    data: (allCalendars) {
      // Filter to selected calendars
      final visibleCalendars = allCalendars
          .where((cal) => selectedIds.value?.contains(cal.id) ?? false)
          .toList();

      // Merge events from all visible calendars
      final Map<DateTime, List<Event>> eventMap = {};
      for (final cal in visibleCalendars) {
        cal.sortEvents();
        cal.events.forEach((date, eventList) {
          eventMap.update(
            date,
            (existing) => [...existing, ...eventList],
            ifAbsent: () => [...eventList],
          );
        });
      }

      // Generate list based on selected day and filter
      List<Event> eventList;
      if (selectedDay != null) {
        // Show events for selected day only
        eventList = eventMap[selectedDay] ?? [];
      } else {
        // Show all events, sorted by time
        eventList = eventMap.values.expand((list) => list).toList();
        eventList.sort((a, b) => a.time.compareTo(b.time));

        // Apply "after today" filter if enabled
        if (afterToday) {
          final now = DateTime.now();
          eventList = eventList
              .where((event) => event.time.isAfter(now))
              .toList();
        }
      }

      return VisibleEvents(map: eventMap, list: eventList);
    },
    loading: () => const VisibleEvents(map: {}, list: []),
    error: (_, _) => const VisibleEvents(map: {}, list: []),
  );
}

/// Data class for visible events (replaces separate map and list providers)
class VisibleEvents {
  final Map<DateTime, List<Event>> map;
  final List<Event> list;

  const VisibleEvents({required this.map, required this.list});
}
