// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';

abstract class CalendarRepository {
  // Calendar operations
  Stream<List<Calendar>> watchAllAvailableCalendars({String? uid});
  Future<List<Calendar>> getAllAvailableCalendars({String? uid});
  Future<void> createCalendar(Calendar calendar);
  Future<Calendar?> getCalendarById(String calendarId);

  /// Updates a calendar and returns the updated calendar with new version.
  /// Throws [ConflictException] if the calendar was modified by another user.
  Future<Calendar> updateCalendar(Calendar calendar);

  Future<void> shareCalendar(String calendarId, String targetUid, bool share);
  Future<void> deleteCalendar(String calendarId);

  // Event operations (subcollection-based)
  Stream<List<Event>> watchEventsForCalendar(String calendarId);
  Stream<List<Event>> watchEventsForCalendars(List<String> calendarIds);
  Future<List<Event>> getEventsForCalendar(String calendarId);

  /// Adds an event and returns the created event with server-assigned version.
  Future<Event> addEvent(String calendarId, Event event);

  /// Updates an event and returns the updated event with new version.
  /// Throws [ConflictException] if the event was modified by another user.
  Future<Event> updateEvent(String calendarId, Event event);

  Future<void> deleteEvent(String calendarId, String eventId);
  Future<void> deleteAllEventsForCalendar(String calendarId);
}
