import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/calendar/calendar.dart';
import 'package:timeshare/data/event/event.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';

part 'cal_providers.g.dart';

@riverpod
CalendarRepository calendarRepository(Ref ref) => CalendarRepository();

@Riverpod(keepAlive: true)
class CalendarNotifier extends _$CalendarNotifier {
  late final CalendarRepository crp;

  @override
  FutureOr<List<Calendar>> build() async {
    crp = ref.watch(calendarRepositoryProvider);
    return await crp.getAllAvailableCalendars();
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
      if (state.valueOrNull != null) ...state.value!,
      calendar,
    ]);

    //handle request errors
    try {
      await crp.addCalendar(calendar);
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
      if (state.valueOrNull != null)
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
      await crp.addEventToCalendar(calendarId: calendarId, event: event);
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
      if (state.valueOrNull != null)
        for (final calendar in state.value!)
          if (calendar.id == calendarId)
            calendar.copyWith(
              events: _removeEventFromMap(calendar.events, event),
            )
          else
            calendar,
    ]);

    try {
      await crp.removeEventFromCalendar(calendarId: calendarId, event: event);
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
      if (state.valueOrNull != null)
        for (final cal in state.value!)
          if (cal.id == calendarId)
            cal.copyWith(
              sharedWith:
                  share
                      ? {...cal.sharedWith, targetUid}.toSet()
                      : cal.sharedWith.where((id) => id != targetUid).toSet(),
            )
          else
            cal,
    ]);
    try {
      await crp.shareCalendar(calendarId, targetUid, share);
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
    final updatedEvents = Map<DateTime, List<Event>>.from(original);

    final updatedList =
        (updatedEvents[day] ?? []).where((e) => e != event).toList();

    if (updatedList.isEmpty) {
      updatedEvents.remove(day);
    } else {
      updatedEvents[day] = updatedList;
    }

    return updatedEvents;
  }
}
