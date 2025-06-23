import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/classes/calendar/calendar.dart';
import 'package:timeshare/classes/event/event.dart';

//FOR TESTING
List<Event> testEvents = [
  Event(title: 'Work', time: DateTime.utc(2025, 6, 15), atendees: ['David']),
  Event(title: 'Brunch', time: DateTime.utc(2025, 6, 30), atendees: ['Maddie']),
];

//for testing
Calendar testCalendar = Calendar.fromList('test', testEvents);

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

DateTime today = normalizeDate(DateTime.now());
