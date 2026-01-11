// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';

void main() {
  group('Calendar', () {
    test('creates calendar with required fields', () {
      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Test Calendar',
      );

      expect(calendar.id, 'cal1');
      expect(calendar.owner, 'user123');
      expect(calendar.name, 'Test Calendar');
    });

    test('has default empty sharedWith set', () {
      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Test Calendar',
      );

      expect(calendar.sharedWith, isEmpty);
    });

    test('has default empty events map', () {
      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Test Calendar',
      );

      expect(calendar.events, isEmpty);
    });

    test('creates calendar with events', () {
      final event = Event(
        name: 'Test Event',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Test Calendar',
        events: {
          DateTime.utc(2024, 6, 15): [event],
        },
      );

      expect(calendar.events.length, 1);
      expect(calendar.events[DateTime.utc(2024, 6, 15)]?.length, 1);
    });

    test('creates calendar with sharedWith users', () {
      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Shared Calendar',
        sharedWith: {'user456', 'user789'},
      );

      expect(calendar.sharedWith.length, 2);
      expect(calendar.sharedWith.contains('user456'), true);
    });

    test('toJson serializes calendar', () {
      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Test Calendar',
        sharedWith: {'user456'},
      );

      final json = calendar.toJson();

      expect(json['id'], 'cal1');
      expect(json['owner'], 'user123');
      expect(json['name'], 'Test Calendar');
    });

    test('fromJson deserializes calendar', () {
      final json = {
        'id': 'cal1',
        'owner': 'user123',
        'name': 'From JSON',
        'sharedWith': <String>[],
        'events': <String, dynamic>{},
      };

      final calendar = Calendar.fromJson(json);

      expect(calendar.id, 'cal1');
      expect(calendar.name, 'From JSON');
    });
  });

  group('Calendar.fromEventList', () {
    test('groups events by normalized date', () {
      final events = [
        Event(
          name: 'Event 1',
          time: DateTime.utc(2024, 6, 15, 10, 0),
          calendarId: 'cal1',
        ),
        Event(
          name: 'Event 2',
          time: DateTime.utc(2024, 6, 15, 14, 0),
          calendarId: 'cal1',
        ),
        Event(
          name: 'Event 3',
          time: DateTime.utc(2024, 6, 16, 9, 0),
          calendarId: 'cal1',
        ),
      ];

      final calendar = Calendar.fromEventList(
        id: 'cal1',
        name: 'From List',
        owner: 'user123',
        eventlist: events,
      );

      expect(calendar.events.length, 2);
      expect(calendar.events[DateTime.utc(2024, 6, 15)]?.length, 2);
      expect(calendar.events[DateTime.utc(2024, 6, 16)]?.length, 1);
    });

    test('handles empty event list', () {
      final calendar = Calendar.fromEventList(
        id: 'cal1',
        name: 'Empty',
        owner: 'user123',
        eventlist: [],
      );

      expect(calendar.events, isEmpty);
    });
  });

  group('Calendar.findCalendarContainingEvent', () {
    test('finds calendar containing event', () {
      final event = Event(
        name: 'Target Event',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Calendar 1',
        events: {
          DateTime.utc(2024, 6, 15): [event],
        },
      );

      final otherCalendar = Calendar(
        id: 'cal2',
        owner: 'user123',
        name: 'Calendar 2',
      );

      final result = Calendar.findCalendarContainingEvent(
        event,
        [otherCalendar, calendar],
      );

      expect(result, calendar);
    });

    test('returns null when event not found', () {
      final event = Event(
        name: 'Missing Event',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Empty Calendar',
      );

      final result = Calendar.findCalendarContainingEvent(event, [calendar]);

      expect(result, isNull);
    });
  });

  group('Calendar.daysInRange', () {
    test('generates days in range', () {
      final first = DateTime.utc(2024, 6, 10);
      final last = DateTime.utc(2024, 6, 15);

      final days = Calendar.daysInRange(first, last);

      expect(days.length, 6);
      expect(days.first, DateTime.utc(2024, 6, 10));
      expect(days.last, DateTime.utc(2024, 6, 15));
    });

    test('handles single day', () {
      final date = DateTime.utc(2024, 6, 15);

      final days = Calendar.daysInRange(date, date);

      expect(days.length, 1);
      expect(days.first, date);
    });
  });

  group('MutCalendar extension', () {
    test('addEvent adds to existing date', () {
      final existingEvent = Event(
        name: 'Existing',
        time: DateTime.utc(2024, 6, 15, 10, 0),
        calendarId: 'cal1',
      );

      final newEvent = Event(
        name: 'New',
        time: DateTime.utc(2024, 6, 15, 14, 0),
        calendarId: 'cal1',
      );

      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Test',
        events: {
          DateTime.utc(2024, 6, 15): [existingEvent],
        },
      );

      final updated = calendar.addEvent(newEvent);

      expect(updated.events[DateTime.utc(2024, 6, 15)]?.length, 2);
    });

    test('addEvent adds to new date', () {
      final event = Event(
        name: 'New Event',
        time: DateTime.utc(2024, 6, 20),
        calendarId: 'cal1',
      );

      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Test',
      );

      final updated = calendar.addEvent(event);

      expect(updated.events.length, 1);
      expect(updated.events[DateTime.utc(2024, 6, 20)]?.length, 1);
    });

    test('removeEvent removes event', () {
      final event = Event(
        name: 'To Remove',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Test',
        events: {
          DateTime.utc(2024, 6, 15): [event],
        },
      );

      final updated = calendar.removeEvent(event);

      expect(updated.events[DateTime.utc(2024, 6, 15)], isNull);
    });

    test('removeEvent removes date key when empty', () {
      final event = Event(
        name: 'Only Event',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Test',
        events: {
          DateTime.utc(2024, 6, 15): [event],
        },
      );

      final updated = calendar.removeEvent(event);

      expect(updated.events.containsKey(DateTime.utc(2024, 6, 15)), false);
    });

    test('removeEvent returns unchanged when event not found', () {
      final event = Event(
        name: 'Not In Calendar',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Test',
      );

      final updated = calendar.removeEvent(event);

      expect(updated.events, calendar.events);
    });

    test('getEvents returns flat list of all events', () {
      final event1 = Event(
        name: 'Event 1',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );
      final event2 = Event(
        name: 'Event 2',
        time: DateTime.utc(2024, 6, 16),
        calendarId: 'cal1',
      );

      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Test',
        events: {
          DateTime.utc(2024, 6, 15): [event1],
          DateTime.utc(2024, 6, 16): [event2],
        },
      );

      final events = calendar.getEvents();

      expect(events.length, 2);
    });

    test('sortEvents sorts chronologically', () {
      final event1 = Event(
        name: 'Later',
        time: DateTime.utc(2024, 6, 20),
        calendarId: 'cal1',
      );
      final event2 = Event(
        name: 'Earlier',
        time: DateTime.utc(2024, 6, 10),
        calendarId: 'cal1',
      );

      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Test',
        events: {
          DateTime.utc(2024, 6, 20): [event1],
          DateTime.utc(2024, 6, 10): [event2],
        },
      );

      final sorted = calendar.sortEvents();
      final events = sorted.getEvents();

      expect(events.first.name, 'Earlier');
      expect(events.last.name, 'Later');
    });

    test('copyEventToDate copies event to new date', () {
      final event = Event(
        name: 'Original',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
        color: Colors.blue,
      );

      final calendar = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Test',
      );

      final updated = calendar.copyEventToDate(
        event: event,
        targetDate: DateTime.utc(2024, 7, 20),
      );

      expect(updated.events[DateTime.utc(2024, 7, 20)]?.length, 1);
      expect(
        updated.events[DateTime.utc(2024, 7, 20)]?.first.name,
        'Original',
      );
    });
  });
}
