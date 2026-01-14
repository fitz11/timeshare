// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:timeshare/data/exceptions/conflict_exception.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';
import 'package:timeshare/data/services/api_client.dart';

/// REST API implementation of [CalendarRepository].
///
/// Designed to work with a Django REST Framework backend.
/// Uses polling for stream-based watch methods since REST doesn't support
/// real-time updates natively.
class RestApiRepository implements CalendarRepository {
  final ApiClient _client;
  final Duration _pollInterval;
  static final _random = Random();

  /// Maximum jitter added to polling interval to prevent synchronized requests.
  static const _maxJitterMs = 5000;

  RestApiRepository({
    required ApiClient client,
    Duration pollInterval = const Duration(seconds: 30),
  })  : _client = client,
        _pollInterval = pollInterval;

  /// Adds random jitter (0-5 seconds) to prevent thundering herd.
  Future<void> _jitter() async {
    await Future<void>.delayed(
      Duration(milliseconds: _random.nextInt(_maxJitterMs)),
    );
  }

  // ============ Calendar Operations ============

  @override
  Stream<List<Calendar>> watchAllAvailableCalendars({String? uid}) async* {
    List<Calendar>? lastValue;

    // Initial fetch
    final initial = await getAllAvailableCalendars(uid: uid);
    lastValue = initial;
    yield initial;

    // Poll for updates with jitter to prevent synchronized requests
    await for (final _ in Stream.periodic(_pollInterval)) {
      await _jitter();
      try {
        final newValue = await getAllAvailableCalendars(uid: uid);
        // Only emit if data actually changed
        if (!listEquals(lastValue, newValue)) {
          lastValue = newValue;
          yield newValue;
        }
      } catch (e) {
        // On error, log and continue polling (don't break stream)
        debugPrint('Calendar polling error (continuing): $e');
      }
    }
  }

  @override
  Future<List<Calendar>> getAllAvailableCalendars({String? uid}) async {
    final response = await _client.get('/api/v1/timeshare/calendars/');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Calendar.fromJson(json)).toList();
  }

  @override
  Future<void> createCalendar(Calendar calendar) async {
    await _client.post(
      '/api/v1/timeshare/calendars/',
      body: jsonEncode(calendar.toJson()),
    );
  }

  @override
  Future<Calendar?> getCalendarById(String calendarId) async {
    try {
      final response = await _client.get('/api/v1/timeshare/calendars/${Uri.encodeComponent(calendarId)}/');
      return Calendar.fromJson(jsonDecode(response.body));
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<void> shareCalendar(
    String calendarId,
    String targetUid,
    bool share,
  ) async {
    // Note: Backend uses camelCase JSON (djangorestframework-camel-case)
    await _client.post(
      '/api/v1/timeshare/calendars/${Uri.encodeComponent(calendarId)}/share/',
      body: jsonEncode({'targetUid': targetUid, 'share': share}),
    );
  }

  @override
  Future<void> deleteCalendar(String calendarId) async {
    await _client.delete('/api/v1/timeshare/calendars/${Uri.encodeComponent(calendarId)}/');
  }

  @override
  Future<Calendar> updateCalendar(Calendar calendar) async {
    try {
      final response = await _client.put(
        '/api/v1/timeshare/calendars/${Uri.encodeComponent(calendar.id)}/',
        body: jsonEncode(calendar.toJson()),
      );
      return Calendar.fromJson(jsonDecode(response.body));
    } on ApiException catch (e) {
      if (e.statusCode == 409 && e.body != null) {
        final serverData = jsonDecode(e.body!);
        final serverCalendar = Calendar.fromJson(serverData['data'] ?? serverData);
        throw ConflictException(
          message: 'Calendar was modified by another user',
          localVersion: calendar.version,
          serverVersion: serverCalendar.version,
          serverData: serverCalendar,
        );
      }
      rethrow;
    }
  }

  // ============ Event Operations ============

  @override
  Stream<List<Event>> watchEventsForCalendar(String calendarId) async* {
    List<Event>? lastValue;

    // Initial fetch
    final initial = await getEventsForCalendar(calendarId);
    lastValue = initial;
    yield initial;

    // Poll for updates with jitter to prevent synchronized requests
    await for (final _ in Stream.periodic(_pollInterval)) {
      await _jitter();
      try {
        final newValue = await getEventsForCalendar(calendarId);
        // Only emit if data actually changed
        if (!listEquals(lastValue, newValue)) {
          lastValue = newValue;
          yield newValue;
        }
      } catch (e) {
        // On error, log and continue polling (don't break stream)
        debugPrint('Event polling error for calendar $calendarId (continuing): $e');
      }
    }
  }

  @override
  Stream<List<Event>> watchEventsForCalendars(List<String> calendarIds) async* {
    if (calendarIds.isEmpty) {
      yield [];
      return;
    }

    List<Event>? lastValue;

    // Initial fetch
    final events = <Event>[];
    for (final id in calendarIds) {
      events.addAll(await getEventsForCalendar(id));
    }
    lastValue = events;
    yield events;

    // Poll for updates with jitter to prevent synchronized requests
    await for (final _ in Stream.periodic(_pollInterval)) {
      await _jitter();
      try {
        final updatedEvents = <Event>[];
        for (final id in calendarIds) {
          updatedEvents.addAll(await getEventsForCalendar(id));
        }
        // Only emit if data actually changed
        if (!listEquals(lastValue, updatedEvents)) {
          lastValue = updatedEvents;
          yield updatedEvents;
        }
      } catch (e) {
        // On error, log and continue polling (don't break stream)
        debugPrint('Events polling error for calendars (continuing): $e');
      }
    }
  }

  @override
  Future<List<Event>> getEventsForCalendar(String calendarId) async {
    final response = await _client.get('/api/v1/timeshare/calendars/${Uri.encodeComponent(calendarId)}/events/');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) {
      // Inject calendarId since it's not stored in event data
      json['calendarId'] = calendarId;
      return Event.fromJson(json);
    }).toList();
  }

  @override
  Future<Event> addEvent(String calendarId, Event event) async {
    final response = await _client.post(
      '/api/v1/timeshare/calendars/${Uri.encodeComponent(calendarId)}/events/',
      body: jsonEncode(event.toJson()),
    );
    final json = jsonDecode(response.body);
    json['calendarId'] = calendarId;
    return Event.fromJson(json);
  }

  @override
  Future<Event> updateEvent(String calendarId, Event event) async {
    try {
      final response = await _client.put(
        '/api/v1/timeshare/calendars/${Uri.encodeComponent(calendarId)}/events/${Uri.encodeComponent(event.id)}/',
        body: jsonEncode(event.toJson()),
      );
      final json = jsonDecode(response.body);
      json['calendarId'] = calendarId;
      return Event.fromJson(json);
    } on ApiException catch (e) {
      if (e.statusCode == 409 && e.body != null) {
        final serverData = jsonDecode(e.body!);
        final eventJson = serverData['data'] ?? serverData;
        eventJson['calendarId'] = calendarId;
        final serverEvent = Event.fromJson(eventJson);
        throw ConflictException(
          message: 'Event was modified by another user',
          localVersion: event.version,
          serverVersion: serverEvent.version,
          serverData: serverEvent,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteEvent(String calendarId, String eventId) async {
    await _client.delete('/api/v1/timeshare/calendars/${Uri.encodeComponent(calendarId)}/events/${Uri.encodeComponent(eventId)}/');
  }

  @override
  Future<void> deleteAllEventsForCalendar(String calendarId) async {
    await _client.delete('/api/v1/timeshare/calendars/${Uri.encodeComponent(calendarId)}/events/');
  }
}
