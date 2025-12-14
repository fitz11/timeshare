// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';

abstract class CalendarRepository {
  Stream<List<Calendar>> watchAllAvailableCalendars({String? uid});
  Future<List<Calendar>> getAllAvailableCalendars({String? uid});
  Future<void> addCalendar(Calendar calendar);
  Future<void> addEventToCalendar({
    required String calendarId,
    required Event event,
  });
  Future<void> removeEventFromCalendar({
    required String calendarId,
    required Event event,
  });
  Future<void> createCalendar(Calendar calendar);

  Future<void> shareCalendar(String calendarId, String targetUid, bool share);

  Future<Calendar?> getCalendarById(String calendarId);

  Future<void> deleteCalendar(String calendarId);
}
