import 'package:flutter/material.dart';

class Event {
  final String title;
  final DateTime time;
  final List<String>? atendees;
  final Color color;
  final BoxShape shape;

  Event(
    this.title,
    this.time, {
    this.atendees,
    this.color = Colors.black,
    this.shape = BoxShape.circle,
  });
}

//FOR TESTING
List<Event> testEvents = [
  Event('Work', DateTime.utc(2025, 6, 15), atendees: ["David"]),
  Event('Brunch', DateTime.utc(2025, 6, 16), atendees: ['Maddie']),
];

//IDK what this is for, the library maker just had it in there
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

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
    final day = DateTime(event.time.year, event.time.month, event.time.day);
    if (events.containsKey(day)) {
      if (!events[day]!.contains(event)) {
        events[day]!.add(event);
      }
    } else {
      events[day] = [event];
    }
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
