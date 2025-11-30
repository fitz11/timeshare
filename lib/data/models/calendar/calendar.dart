// Timeshare: a cross-platform app to make and share calendars.
// Copyright (C) 2025  David Fitzsimmons
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/converters/eventmap_converter.dart';
import 'package:timeshare/data/converters/set_converter.dart';

part 'calendar.freezed.dart';
part 'calendar.g.dart';

@freezed
abstract class Calendar with _$Calendar {
  factory Calendar({
    required String id,
    required String owner,
    @SetConverter() @Default({}) Set<String> sharedWith,
    required String name,
    // ignore: invalid_annotation_target
    @EventMapLoader() @Default({}) Map<DateTime, List<Event>> events,
  }) = _Calendar;

  factory Calendar.fromJson(Map<String, dynamic> json) =>
      _$CalendarFromJson(json);

  factory Calendar.fromEventList({
    required String id,
    required String name,
    required String owner,
    required List<Event> eventlist,
  }) {
    final copiedList = eventlist.map((e) => e.copyWith());
    final eventmap = copiedList.fold<Map<DateTime, List<Event>>>({}, (
      map,
      event,
    ) {
      final day = normalizeDate(event.time);
      map.putIfAbsent(day, () => []).add(event);
      return map;
    });
    return Calendar(id: id, name: name, owner: owner, events: eventmap);
  }

  /// helper function to find which (if any) calendar has an event.
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

  /// helper function to generate DateTimes over a range
  static List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }
}

extension MutCalendar on Calendar {
  Calendar addEvent(Event event) {
    final copiedEvent = event.copyWith();
    final date = normalizeDate(event.time);
    final updatedEvents = Map<DateTime, List<Event>>.from(events)
      ..update(
        date,
        (list) => [...list, copiedEvent],
        ifAbsent: () => [copiedEvent],
      );
    return copyWith(events: updatedEvents);
  }

  ///returns a DEEP COPY of each event
  List<Event> getEvents() {
    return events.values
        .expand((eventlist) => eventlist.map((e) => e.copyWith()))
        .toList();
  }

  //maybe unnecessary; leaving for legacy reasons?
  Calendar copyEventToDate({
    required Event event,
    required DateTime targetDate,
  }) {
    final copiedEvent = event.copyWith(time: targetDate);
    final normalizedDate = normalizeDate(targetDate);

    final updatedEvents = Map<DateTime, List<Event>>.from(events)
      ..update(
        normalizedDate,
        (list) => [...list, copiedEvent],
        ifAbsent: () => [copiedEvent],
      );

    return copyWith(events: updatedEvents);
  }

  Calendar removeEvent(Event event) {
    final date = normalizeDate(event.time);
    final currentList = events[date];

    if (currentList == null) return this;

    final updatedList = currentList.where((e) => e != event).toList();
    final updatedEvents = Map<DateTime, List<Event>>.from(events);

    if (updatedList.isEmpty) {
      updatedEvents.remove(date);
    } else {
      updatedEvents[date] = updatedList;
    }
    return copyWith(events: updatedEvents);
  }

  Calendar sortEvents([bool forward = true]) {
    List<Event> sorted = getEvents();
    if (forward) {
      sorted.sort((a, b) => a.time.compareTo(b.time));
    } else {
      sorted.sort((a, b) => a.time.compareTo(b.time));
    }
    final eventmap = sorted.fold<Map<DateTime, List<Event>>>({}, (map, event) {
      final day = normalizeDate(event.time);
      map.putIfAbsent(day, () => []).add(event);
      return map;
    });
    return copyWith(events: eventmap);
  }

  String dbgOutput() {
    String toreturn = '$name: \n';
    events.forEach((key, value) {
      toreturn += '--date: ${normalizeDate(key)} : \n';
      for (var element in value) {
        toreturn += '----${element.dbgOutput()}';
      }
    });
    return toreturn;
  }
}
