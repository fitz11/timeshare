// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/converters/eventmap_converter.dart';
import 'package:timeshare/data/models/event/event.dart';

void main() {
  const converter = EventMapLoader();

  group('EventMapLoader', () {
    test('fromJson converts JSON to event map', () {
      final json = <String, dynamic>{
        '2024-06-15T00:00:00.000Z': [
          {
            'name': 'Test Event',
            'time': '2024-06-15T10:00:00.000Z',
            'calendarId': 'cal1',
            'color': Colors.blue.toARGB32(),
            'shape': 'circle',
          },
        ],
      };

      final map = converter.fromJson(json);

      expect(map.length, 1);
      expect(map.keys.first, DateTime.utc(2024, 6, 15));
      expect(map.values.first.length, 1);
      expect(map.values.first.first.name, 'Test Event');
    });

    test('fromJson handles empty map', () {
      final json = <String, dynamic>{};
      final map = converter.fromJson(json);
      expect(map, isEmpty);
    });

    test('fromJson handles multiple dates', () {
      final json = <String, dynamic>{
        '2024-06-15T00:00:00.000Z': [
          {
            'name': 'Event 1',
            'time': '2024-06-15T10:00:00.000Z',
            'calendarId': 'cal1',
            'color': Colors.blue.toARGB32(),
            'shape': 'circle',
          },
        ],
        '2024-06-16T00:00:00.000Z': [
          {
            'name': 'Event 2',
            'time': '2024-06-16T10:00:00.000Z',
            'calendarId': 'cal1',
            'color': Colors.red.toARGB32(),
            'shape': 'rectangle',
          },
        ],
      };

      final map = converter.fromJson(json);
      expect(map.length, 2);
    });

    test('toJson converts event map to JSON', () {
      final event = Event(
        name: 'Test Event',
        time: DateTime.utc(2024, 6, 15, 10, 0),
        calendarId: 'cal1',
        color: Colors.blue,
        shape: BoxShape.circle,
      );

      final map = <DateTime, List<Event>>{
        DateTime.utc(2024, 6, 15): [event],
      };

      final json = converter.toJson(map);

      expect(json.length, 1);
      expect(json.keys.first, '2024-06-15T00:00:00.000Z');
      expect((json.values.first as List).length, 1);
    });

    test('toJson handles empty map', () {
      final map = <DateTime, List<Event>>{};
      final json = converter.toJson(map);
      expect(json, isEmpty);
    });

    test('roundtrip preserves event data', () {
      final event = Event(
        name: 'Roundtrip Event',
        time: DateTime.utc(2024, 7, 20, 14, 30),
        calendarId: 'cal1',
        color: Colors.green,
        shape: BoxShape.rectangle,
      );

      final original = <DateTime, List<Event>>{
        DateTime.utc(2024, 7, 20): [event],
      };

      final json = converter.toJson(original);
      final restored = converter.fromJson(json);

      expect(restored.length, 1);
      expect(restored.values.first.first.name, event.name);
      expect(restored.values.first.first.calendarId, event.calendarId);
    });
  });

  group('eventMapToJson (standalone)', () {
    test('converts event map to JSON', () {
      final event = Event(
        name: 'Standalone Test',
        time: DateTime.utc(2024, 8, 1, 9, 0),
        calendarId: 'cal2',
      );

      final map = <DateTime, List<Event>>{
        DateTime.utc(2024, 8, 1): [event],
      };

      final json = eventMapToJson(map);
      expect(json.isNotEmpty, true);
    });
  });

  group('eventMapFromJson (standalone)', () {
    test('converts JSON to event map', () {
      final json = <String, dynamic>{
        '2024-08-01T00:00:00.000Z': [
          {
            'name': 'Standalone Event',
            'time': '2024-08-01T09:00:00.000Z',
            'calendarId': 'cal2',
            'color': Colors.black.toARGB32(),
            'shape': 'circle',
          },
        ],
      };

      final map = eventMapFromJson(json);
      expect(map.length, 1);
      expect(map.values.first.first.name, 'Standalone Event');
    });
  });
}
