import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/calendar/calendar.dart';
import 'package:timeshare/data/event/event.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';
import 'package:timeshare/data/repo/user_repo.dart';
import 'package:timeshare/data/user/app_user.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});

//homepage nav provider; defaults to calendar page
final bottomNavIndexProvider = StateProvider<int>((ref) => 1);

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  final uid = repo.currentUserId;
  if (uid == null) return null;
  return await repo.getUserById(uid);
});

final userFriendsProvider = FutureProvider<List<AppUser>>((ref) async {
  print('__friends provider called__');
  final user = ref.read(currentUserProvider);
  final repo = ref.read(userRepositoryProvider);
  return await repo.getFriendsOfUser(user.value!.uid);
});

final userSearchProvider = FutureProvider.family<List<AppUser>, String>((
  ref,
  email,
) async {
  final repo = ref.read(userRepositoryProvider);
  return await repo.searchUserByEmail(email);
});

///One day can help support batch read/writes to save
/// on my firestore needs.
class CalendarNotifier extends StateNotifier<List<Calendar>> {
  final CalendarRepository _repo;
  CalendarNotifier(this._repo) : super([]);

  Future<void> loadAllCalendars({String? uid}) async {
    final calendars = await _repo.getAllAvailableCalendars(uid: uid);
    state = calendars;
  }

  Future<void> addCalendar({
    required String ownerUid,
    required String name,
  }) async {
    print('adding calendar ${ownerUid}_$name ...');
    final calendar = Calendar(
      id: '${ownerUid}_$name',
      owner: ownerUid,
      name: name,
      events: <DateTime, List<Event>>{},
    );
    await _repo.addCalendar(calendar);
    state = [...state, calendar];
    print('added calendar!');
  }

  Future<void> addEventToCalendar({
    required String calendarId,
    required Event event,
  }) async {
    await _repo.addEventToCalendar(calendarId: calendarId, event: event);

    // Then update local state
    state = [
      for (final calendar in state)
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
    ];
  }

  Future<void> removeEvent({
    required String calendarId,
    required Event event,
  }) async {
    await _repo.removeEventFromCalendar(calendarId: calendarId, event: event);

    // Update local in-memory state
    state = [
      for (final cal in state)
        if (cal.id == calendarId)
          cal.copyWith(events: _removeEventFromMap(cal.events, event))
        else
          cal,
    ];
  }

  Future<void> shareCalendar(
    String calendarId,
    String targetUid,
    bool share,
  ) async {
    await _repo.shareCalendar(calendarId, targetUid, share);
    state = [
      for (final cal in state)
        if (cal.id == calendarId)
          cal.copyWith(
            sharedWith:
                share
                    ? {...cal.sharedWith, targetUid}.toSet()
                    : cal.sharedWith.where((id) => id != targetUid).toSet(),
          )
        else
          cal,
    ];
    print('calendar $calendarId shared with $targetUid');
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

final calendarNotifierProvider =
    StateNotifierProvider<CalendarNotifier, List<Calendar>>((ref) {
      return CalendarNotifier(CalendarRepository());
    });

final selectedCalendarsProvider =
    StateNotifierProvider<SelectedCalendarsNotifier, Set<String>>((ref) {
      return SelectedCalendarsNotifier();
    });

class SelectedCalendarsNotifier extends StateNotifier<Set<String>> {
  SelectedCalendarsNotifier() : super({});

  void add(String id) => state = {...state, id};
  void remove(String id) => state = state.where((e) => e != id).toSet();
  void clear() => state = {};
}

///provides the events which are visible based on the filter applied from
///the selected calendars
final visibleEventsMapProvider = Provider<Map<DateTime, List<Event>>>((ref) {
  final calendars = ref.watch(calendarNotifierProvider);
  final selectedIds = ref.watch(selectedCalendarsProvider);
  final visibleCalendars = calendars.where(
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
});

final visibleEventsListProvider = Provider<List<Event>>((ref) {
  final eventMap = ref.watch(visibleEventsMapProvider);
  return eventMap.values.expand((list) => list).toList();
});

final selectedDayProvider = Provider<DateTime>((ref) {
  return normalizeDate(DateTime.now());
});

final eventsForSelectedDayProvider = Provider<List<Event>>((ref) {
  final selectedDay = ref.watch(selectedDayProvider);
  final visibleEvents = ref.watch(visibleEventsMapProvider);

  return visibleEvents[normalizeDate(selectedDay)] ?? [];
});
