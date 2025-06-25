import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/calendar/calendar.dart';
import 'package:timeshare/data/event/event.dart';

//FOR TESTING
List<Event> testEvents = [
  Event(name: 'Work', time: DateTime.utc(2025, 6, 15), atendees: ['David']),
  Event(name: 'Brunch', time: DateTime.utc(2025, 6, 30), atendees: ['Maddie']),
];

//for testing
Calendar testCalendar = Calendar.fromEventList(
  id: '5X6JyQULsRd8kLJB4x8A9qXn7xI3_test',
  name: 'test',
  owner: '5X6JyQULsRd8kLJB4x8A9qXn7xI3',
  eventlist: testEvents,
);

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

DateTime today = normalizeDate(DateTime.now());
