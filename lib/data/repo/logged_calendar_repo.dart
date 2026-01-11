import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';
import 'package:timeshare/services/logging/app_logger.dart';

/// Decorator that wraps a CalendarRepository to add logging.
///
/// All Firestore operations are logged with timing metrics.
/// Stream subscriptions are logged when created.
class LoggedCalendarRepository implements CalendarRepository {
  final CalendarRepository _delegate;
  final AppLogger _logger;

  LoggedCalendarRepository(this._delegate, this._logger);

  // Calendar operations

  @override
  Stream<List<Calendar>> watchAllAvailableCalendars({String? uid}) {
    _logger.logStreamSubscription('watchAllAvailableCalendars');
    return _delegate.watchAllAvailableCalendars(uid: uid);
  }

  @override
  Future<List<Calendar>> getAllAvailableCalendars({String? uid}) {
    return _logger.logApiCall(
      'getAllAvailableCalendars',
      () => _delegate.getAllAvailableCalendars(uid: uid),
    );
  }

  @override
  Future<void> createCalendar(Calendar calendar) {
    return _logger.logApiCall(
      'createCalendar',
      () => _delegate.createCalendar(calendar),
    );
  }

  @override
  Future<Calendar?> getCalendarById(String calendarId) {
    return _logger.logApiCall(
      'getCalendarById',
      () => _delegate.getCalendarById(calendarId),
    );
  }

  @override
  Future<void> shareCalendar(String calendarId, String targetUid, bool share) {
    return _logger.logApiCall(
      'shareCalendar',
      () => _delegate.shareCalendar(calendarId, targetUid, share),
    );
  }

  @override
  Future<void> deleteCalendar(String calendarId) {
    return _logger.logApiCall(
      'deleteCalendar',
      () => _delegate.deleteCalendar(calendarId),
    );
  }

  // Event operations

  @override
  Stream<List<Event>> watchEventsForCalendar(String calendarId) {
    _logger.logStreamSubscription('watchEventsForCalendar');
    return _delegate.watchEventsForCalendar(calendarId);
  }

  @override
  Stream<List<Event>> watchEventsForCalendars(List<String> calendarIds) {
    _logger.logStreamSubscription(
      'watchEventsForCalendars(${calendarIds.length} calendars)',
    );
    return _delegate.watchEventsForCalendars(calendarIds);
  }

  @override
  Future<List<Event>> getEventsForCalendar(String calendarId) {
    return _logger.logApiCall(
      'getEventsForCalendar',
      () => _delegate.getEventsForCalendar(calendarId),
    );
  }

  @override
  Future<void> addEvent(String calendarId, Event event) {
    return _logger.logApiCall(
      'addEvent',
      () => _delegate.addEvent(calendarId, event),
    );
  }

  @override
  Future<void> updateEvent(String calendarId, Event event) {
    return _logger.logApiCall(
      'updateEvent',
      () => _delegate.updateEvent(calendarId, event),
    );
  }

  @override
  Future<void> deleteEvent(String calendarId, String eventId) {
    return _logger.logApiCall(
      'deleteEvent',
      () => _delegate.deleteEvent(calendarId, eventId),
    );
  }

  @override
  Future<void> deleteAllEventsForCalendar(String calendarId) {
    return _logger.logApiCall(
      'deleteAllEventsForCalendar',
      () => _delegate.deleteAllEventsForCalendar(calendarId),
    );
  }
}
