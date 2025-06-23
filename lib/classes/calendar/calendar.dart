import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/classes/event/event.dart';

part 'calendar.freezed.dart';
part 'calendar.g.dart';

@freezed
abstract class Calendar with _$Calendar {
  factory Calendar({
    required String name,
    required Map<DateTime, List<Event>> events,
  }) = _Calendar;

  factory Calendar.fromJson(Map<String, dynamic> json) =>
      _$CalendarFromJson(json);

  factory Calendar.fromList(String name, List<Event> eventlist) {
    final copiedList = eventlist.map((e) => e.copyWith());
    final eventmap = copiedList.fold<Map<DateTime, List<Event>>>({}, (
      map,
      event,
    ) {
      final day = normalizeDate(event.time);
      map.putIfAbsent(day, () => []).add(event);
      return map;
    });
    return Calendar(name: name, events: eventmap);
  }

  //helper function to find if a calendar has an event
  static Calendar? findCalendarContainingEvent(
    Event event,
    List<Calendar> calendars,
  ) {
    for (var calendar in calendars) {
      for (var eventList in calendar.events.values) {
        if (eventList.contains(event)) {
          return calendar;
        }
      }
    }
    return null;
  }

  static List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }
}

extension CalendarX on Calendar {
  Calendar addEvent(Event event) {
    final copiedEvent = event.copyWith();
    final date = normalizeDate(event.time);
    final updatedEvents = Map<DateTime, List<Event>>.from(events)..update(
      date,
      (list) => [...list, copiedEvent],
      ifAbsent: () => [copiedEvent],
    );
    return copyWith(events: updatedEvents);
  }

  ///returns a DEEP COPY of each event
  List<Event> getEvents() {
    return events.values
        .expand((eventlist) => eventlist.map((e) => e.copyWith()))
        .toList();
  }

  //maybe unnecessary; leaving for legacy reasons?
  Calendar copyEventToDate({
    required Event event,
    required DateTime targetDate,
  }) {
    final copiedEvent = event.copyWith(time: targetDate);
    final normalizedDate = normalizeDate(targetDate);

    final updatedEvents = Map<DateTime, List<Event>>.from(events)..update(
      normalizedDate,
      (list) => [...list, copiedEvent],
      ifAbsent: () => [copiedEvent],
    );

    return copyWith(events: updatedEvents);
  }

  Calendar removeEvent(Event event) {
    final date = normalizeDate(event.time);
    final currentList = events[date];

    if (currentList == null) return this;

    final updatedList = currentList.where((e) => e != event).toList();
    final updatedEvents = Map<DateTime, List<Event>>.from(events);

    if (updatedList.isEmpty) {
      updatedEvents.remove(date);
    } else {
      updatedEvents[date] = updatedList;
    }
    return copyWith(events: updatedEvents);
  }

  String dbgOutput() {
    String toreturn = '$name: \n';
    events.forEach((key, value) {
      toreturn += '--date: ${normalizeDate(key)} : \n';
      for (var element in value) {
        toreturn += '----${element.dbgOutput()}';
      }
    });
    return toreturn;
  }
}
