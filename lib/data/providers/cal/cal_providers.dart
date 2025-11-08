import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';

part 'cal_providers.g.dart';

@riverpod
class CalendarNotifier extends _$CalendarNotifier {
  late final CalendarRepository _crp;

  @override
  Future<List<Calendar>> build() async {
    _crp = CalendarRepository();
    return await _crp.getAllAvailableCalendars();
  }

  Future<void> addCalendar({
    required String ownerUid,
    required String name,
  }) async {
    print('Adding calendar ${ownerUid}_$name ...');
    final previousState = state;

    final calendar = Calendar(
      id: '${ownerUid}_$name',
      owner: ownerUid,
      name: name,
      events: <DateTime, List<Event>>{},
    );

    //update local state
    state = AsyncValue.data([
      if (state.value != null) ...state.value!,
      calendar,
    ]);

    //handle request errors
    try {
      await _crp.addCalendar(calendar);
      print('Success!');
    } catch (e) {
      state = previousState;
      print('error sending to firestore: $e');
    }
  }

  Future<void> addEventToCalendar({
    required String calendarId,
    required Event event,
  }) async {
    print('Adding event to calendar: ${calendarId}_${event.name} ...');
    final previousState = state;

    state = AsyncValue.data([
      if (state.value != null)
        for (final calendar in state.value!)
          if (calendar.id == calendarId)
            calendar.copyWith(
              events: {
                ...calendar.events,
                normalizeDate(event.time): [
                  ...(calendar.events[normalizeDate(event.time)] ?? []),
                  event,
                ],
              },
            )
          else
            calendar,
    ]);

    try {
      await _crp.addEventToCalendar(calendarId: calendarId, event: event);
      print('Success adding event');
    } catch (e) {
      state = previousState;
      print('error adding event to firestore: $e');
    }
  }

  Future<void> removeEvent({
    required String calendarId,
    required Event event,
  }) async {
    print('removing ${event.name} from $calendarId ...');
    final previousState = state;

    state = AsyncValue.data([
      if (state.value != null)
        for (final calendar in state.value!)
          if (calendar.id == calendarId)
            calendar.copyWith(
              events: _removeEventFromMap(calendar.events, event),
            )
          else
            calendar,
    ]);

    try {
      await _crp.removeEventFromCalendar(calendarId: calendarId, event: event);
      print('Success removing event');
    } catch (e) {
      state = previousState;
      print('error adding event to firestore: $e');
    }
  }

  Future<void> shareCalendar(
    String calendarId,
    String targetUid,
    bool share,
  ) async {
    final previousState = state;
    print('setting share state for $calendarId with $targetUid to $share');

    state = AsyncValue.data([
      if (state.value != null)
        for (final cal in state.value!)
          if (cal.id == calendarId)
            cal.copyWith(
              sharedWith: share
                  ? {...cal.sharedWith, targetUid}.toSet()
                  : cal.sharedWith.where((id) => id != targetUid).toSet(),
            )
          else
            cal,
    ]);
    try {
      await _crp.shareCalendar(calendarId, targetUid, share);
      print('calendar share state updated success');
    } catch (e) {
      state = previousState;
      print('error sharing calendar: $e');
    }
  }

  Map<DateTime, List<Event>> _removeEventFromMap(
    Map<DateTime, List<Event>> original,
    Event event,
  ) {
    final day = normalizeDate(event.time);
    final updatedEvents = Map<DateTime, List<Event>>.of(original);

    final updatedList = (updatedEvents[day] ?? [])
        .where((e) => e != event)
        .toList();

    if (updatedList.isEmpty) {
      updatedEvents.remove(day);
    } else {
      updatedEvents[day] = updatedList;
    }

    return updatedEvents;
  }
}

@riverpod
class SelectedCalIdsNotifier extends _$SelectedCalIdsNotifier {
  @override
  Set<String> build() {
    final allCalendarIds = ref
        .watch(calendarProvider)
        .requireValue
        .fold<Set<String>>({}, (prev, cal) => {...prev, cal.id});
    return allCalendarIds;
  }

  void add(String id) => state.add(id);
  void remove(String id) => state = state.where((e) => e != id).toSet();
  void clear() => state = {};

  List<Calendar> selectedCalendars() {
    final allCalendars = ref.watch(calendarProvider).requireValue;
    return allCalendars.where((cal) => state.contains(cal.id)).toList();
  }
}

@riverpod
Map<DateTime, List<Event>> visibleEventsMap(Ref ref) {
  final calendars = ref.watch(calendarProvider);
  final selectedIds = ref.watch(selectedCalIdsProvider);
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
  final selectedDay = ref.watch(selectedDayProvider);
  final afterToday = ref.watch(afterTodayProvider);
  if (selectedDay == null) {
    List<Event> eventsList = eventMap.values.expand((list) => list).toList();
    eventsList.sort((a, b) => a.time.compareTo(b.time));
    if (afterToday) {
      eventsList.removeWhere((event) => event.time.isBefore(DateTime.now()));
    }
    return eventsList;
  } else {
    List<Event> eventsList = eventMap[selectedDay] ?? [];
    return eventsList;
  }
}

@riverpod
class SelectedDayNotifier extends _$SelectedDayNotifier {
  @override
  DateTime? build() {
    return null;
  }

  void selectDay(DateTime selected) => state = normalizeDate(selected);
  void clear() => state = null;
}

@riverpod
class AfterTodayNotifier extends _$AfterTodayNotifier {
  @override
  bool build() {
    return true;
  }

  void on() => state = true;
  void off() => state = false;
  void toggle() => state = !state;
}

@riverpod
class CopyModeNotifier extends _$CopyModeNotifier {
  @override
  bool build() {
    return false;
  }

  void change() => state = !state;
  void on() => state = true;
  void off() => state = false;
}

// TODO: implement delete mode
@riverpod
class DeleteModeNotifier extends _$DeleteModeNotifier {
  @override
  bool build() {
    return false;
  }

  void change() => state = !state;
  void on() => state = true;
  void off() => state = false;
}

@riverpod
class CopyEventNotifier extends _$CopyEventNotifier {
  @override
  Event? build() {
    return null;
  }

  void setCopyEvent(Event e) => state = e.copyWith();
}
