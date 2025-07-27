import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeshare/data/calendar/calendar.dart';
import 'package:timeshare/data/event/event.dart';
import 'package:timeshare/data/providers/cal_providers.dart';

part 'sel_cal_providers.g.dart';

@riverpod
class SelectedCalIdsNotifier extends _$SelectedCalIdsNotifier {
  @override
  Set<String> build() {
    final allCalendarIds = ref
        .watch(calendarNotifierProvider)
        .requireValue
        .fold<Set<String>>({}, (prev, cal) => {...prev, cal.id});
    return allCalendarIds;
  }

  void add(String id) => state = {...state, id};
  void remove(String id) => state = state.where((e) => e != id).toSet();
  void clear() => state = {};
}

@riverpod
List<Calendar> selectedCalendars(Ref ref) {
  final selectedIds = ref.watch(selectedCalIdsNotifierProvider);
  final allCalendars = ref.watch(calendarNotifierProvider).requireValue;
  return allCalendars.where((cal) => selectedIds.contains(cal.id)).toList();
}

@riverpod
Map<DateTime, List<Event>> visibleEventsMap(Ref ref) {
  final calendars = ref.watch(calendarNotifierProvider);
  final selectedIds = ref.watch(selectedCalIdsNotifierProvider);
  final visibleCalendars = calendars.requireValue.where(
    (cal) => selectedIds.contains(cal.id),
  );

  final Map<DateTime, List<Event>> mergedEvents = {};

  for (final cal in visibleCalendars) {
    cal.sortEvents();
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
  List<Event> eventsList = eventMap.values.expand((list) => list).toList();
  eventsList.sort((a, b) => a.time.compareTo(b.time));
  return eventsList;
}
