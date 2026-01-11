import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';

abstract class CalendarRepository {
  // Calendar operations
  Stream<List<Calendar>> watchAllAvailableCalendars({String? uid});
  Future<List<Calendar>> getAllAvailableCalendars({String? uid});
  Future<void> createCalendar(Calendar calendar);
  Future<Calendar?> getCalendarById(String calendarId);
  Future<void> shareCalendar(String calendarId, String targetUid, bool share);
  Future<void> deleteCalendar(String calendarId);

  // Event operations (subcollection-based)
  Stream<List<Event>> watchEventsForCalendar(String calendarId);
  Stream<List<Event>> watchEventsForCalendars(List<String> calendarIds);
  Future<List<Event>> getEventsForCalendar(String calendarId);
  Future<void> addEvent(String calendarId, Event event);
  Future<void> updateEvent(String calendarId, Event event);
  Future<void> deleteEvent(String calendarId, String eventId);
  Future<void> deleteAllEventsForCalendar(String calendarId);
}
