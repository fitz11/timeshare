import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';

class CalendarCache {
  final Map<String, dynamic> _calendars;
  final List<Calendar> localCalendars;
  final List<Event> localEventList;
  final Map<DateTime, List<Event>> localEventMap;

  CalendarCache({
    Map<String, dynamic>? calendars,
    List<Calendar>? localCalendars,
    List<Event>? localEventList,
    Map<DateTime, List<Event>>? localEventMap,
  }) : _calendars = calendars ?? {},
       localCalendars = localCalendars ?? <Calendar>[],
       localEventList = localEventList ?? <Event>[],
       localEventMap = localEventMap ?? <DateTime, List<Event>>{};

  dynamic get(String key) => _calendars[key];
  void set(String key, dynamic value) => _calendars[key] = value;
  bool contains(String key) => _calendars.containsKey(key);
}
