import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  final DateTime time;
  final List<String>? atendees;
  final Color color;
  final BoxShape shape;

  Event({
    required this.title,
    required this.time,
    this.atendees,
    this.color = Colors.black,
    this.shape = BoxShape.circle,
  });

  Event copy() => Event(
    title: title,
    time: time,
    atendees: atendees,
    color: color,
    shape: shape,
  );

  Event copyWith({
    String? title,
    DateTime? time,
    List<String>? atendees,
    Color? color,
    BoxShape? shape,
  }) {
    return Event(
      title: title ?? this.title,
      time: time ?? this.time,
      atendees: atendees ?? this.atendees,
      color: color ?? this.color,
      shape: shape ?? this.shape,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Event &&
        other.title == title &&
        other.time == time &&
        listEquals(other.atendees, atendees) &&
        other.color == color &&
        other.shape == shape;
  }

  @override
  int get hashCode => Object.hash(title, time, atendees, color, shape);

  @override
  String toString() {
    return "$title: ${DateFormat.yMMMd().format(time)} : ${color.toString()} : ${shape.toString()}\n";
  }
}

//FOR TESTING
List<Event> testEvents = [
  Event(title: 'Work', time: DateTime.utc(2025, 6, 15), atendees: ["David"]),
  Event(title: 'Brunch', time: DateTime.utc(2025, 6, 16), atendees: ['Maddie']),
];

//unused as of now
class Calendar {
  final String name;
  final Map<DateTime, List<Event>> events;

  Calendar({required this.name, required this.events});

  ///creates a calendar from a list of events (and a name).
  ///The resulting events variable strips the time from the event
  ///for better use with the calendarbuilder, so the key DateTime
  ///does not store date information.
  factory Calendar.fromList(String name, List<Event> eventlist) {
    final eventmap = eventlist.fold<Map<DateTime, List<Event>>>({}, (
      map,
      event,
    ) {
      final day = DateTime(event.time.year, event.time.month, event.time.day);
      map.putIfAbsent(day, () => []).add(event);
      return map;
    });
    return Calendar(name: name, events: eventmap);
  }

  List<Event> getEvents() {
    return events.values.expand((eventlist) => eventlist).toList();
  }

  void addEvent(Event event) {
    final copiedEvent = event.copy();
    final date = DateTime(event.time.year, event.time.month, event.time.day);
    if (events.containsKey(date)) {
      if (!events[date]!.contains(copiedEvent)) {
        events[date]!.add(copiedEvent);
      }
    } else {
      events[date] = [copiedEvent];
    }
  }

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

  void copyEventToDate({required Event event, required DateTime targetDate}) {
    final copiedEvent = event.copyWith(time: targetDate);
    final normalizedDate = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    events.update(normalizedDate, (list) {
      return [...list, copiedEvent];
    }, ifAbsent: () => [copiedEvent]);
  }

  @override
  String toString() {
    String toreturn = '$name: \n';
    events.forEach((key, value) {
      toreturn += '--  date: ${normalizeDate(key)} : \n';
      for (var element in value) {
        toreturn += '----${element.toString()}';
      }
    });
    return toreturn;
  }
}

//for testing
Calendar testCalendar = Calendar.fromList("test", testEvents);

//FOR MORE TESTING
DateTime today = DateTime.now();
DateTime firstDay = DateTime.now().subtract(const Duration(days: 365));
DateTime lastDay = DateTime.now().add(const Duration(days: 365));

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}
