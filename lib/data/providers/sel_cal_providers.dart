import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/event/event.dart';
import 'package:timeshare/data/providers/new_cal_providers.dart';

part 'sel_cal_providers.g.dart';

@riverpod
class SelectedCalendarsNotifier extends _$SelectedCalendarsNotifier {
  @override
  Set<String> build() {
    return <String>{};
  }

  void add(String id) => state = {...state, id};
  void remove(String id) => state = state.where((e) => e != id).toSet();
  void clear() => state = {};
}

@riverpod
Map<DateTime, List<Event>> visibleEventsMap(Ref ref) {
  final calendars = ref.watch(calendarNotifierProvider);
  final selectedIds = ref.watch(selectedCalendarsNotifierProvider);
  final visibleCalendars = calendars.requireValue.where(
    (cal) => selectedIds.contains(cal.id),
  );

  final Map<DateTime, List<Event>> mergedEvents = {};

  for (final cal in visibleCalendars) {
    cal.events.forEach((date, eventList) {
      mergedEvents.update(
        date,
        (existing) => [...existing, ...eventList],
        ifAbsent: () => [...eventList],
      );
    });
  }
  return mergedEvents;
}

@riverpod
List<Event> visibleEventsList(Ref ref) {
  final eventMap = ref.watch(visibleEventsMapProvider);
  return eventMap.values.expand((list) => list).toList();
}

@riverpod
DateTime selectedDay(Ref ref) {
  return normalizeDate(DateTime.now());
}

@riverpod
List<Event> eventsForSelectedDay(Ref ref) {
  final selectedDay = ref.watch(selectedDayProvider);
  final visibleEvents = ref.watch(visibleEventsMapProvider);
  return visibleEvents[normalizeDate(selectedDay)] ?? [];
}
