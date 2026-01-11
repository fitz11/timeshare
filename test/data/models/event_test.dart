// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/models/event/event.dart';

void main() {
  group('Event', () {
    test('creates event with required fields', () {
      final event = Event(
        name: 'Test Event',
        time: DateTime.utc(2024, 6, 15, 10, 0),
        calendarId: 'cal1',
      );

      expect(event.name, 'Test Event');
      expect(event.time, DateTime.utc(2024, 6, 15, 10, 0));
      expect(event.calendarId, 'cal1');
    });

    test('creates event with all fields', () {
      final event = Event(
        name: 'Full Event',
        time: DateTime.utc(2024, 6, 15, 14, 30),
        calendarId: 'cal1',
        atendees: ['user1', 'user2'],
        color: Colors.red,
        shape: BoxShape.rectangle,
      );

      expect(event.name, 'Full Event');
      expect(event.atendees, ['user1', 'user2']);
      expect(event.color, Colors.red);
      expect(event.shape, BoxShape.rectangle);
    });

    test('has default color of black', () {
      final event = Event(
        name: 'Default Color',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      expect(event.color, Colors.black);
    });

    test('has default shape of circle', () {
      final event = Event(
        name: 'Default Shape',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      expect(event.shape, BoxShape.circle);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = Event(
        name: 'Original',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
        color: Colors.blue,
      );

      final copied = original.copyWith(name: 'Copied');

      expect(copied.name, 'Copied');
      expect(copied.time, original.time);
      expect(copied.calendarId, original.calendarId);
      expect(copied.color, original.color);
    });

    test('copyWith preserves original when no changes', () {
      final original = Event(
        name: 'Original',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      final copied = original.copyWith();

      expect(copied.name, original.name);
      expect(copied.time, original.time);
      expect(copied.calendarId, original.calendarId);
    });

    test('equality works correctly', () {
      final event1 = Event(
        name: 'Same Event',
        time: DateTime.utc(2024, 6, 15, 10, 0),
        calendarId: 'cal1',
        color: Colors.blue,
      );

      final event2 = Event(
        name: 'Same Event',
        time: DateTime.utc(2024, 6, 15, 10, 0),
        calendarId: 'cal1',
        color: Colors.blue,
      );

      expect(event1, event2);
    });

    test('inequality for different names', () {
      final event1 = Event(
        name: 'Event 1',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      final event2 = Event(
        name: 'Event 2',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      expect(event1, isNot(event2));
    });

    test('toJson serializes event', () {
      final event = Event(
        name: 'JSON Event',
        time: DateTime.utc(2024, 6, 15, 10, 0),
        calendarId: 'cal1',
        color: Colors.blue,
        shape: BoxShape.circle,
      );

      final json = event.toJson();

      expect(json['name'], 'JSON Event');
      expect(json['calendarId'], 'cal1');
      expect(json['shape'], 'circle');
    });

    test('fromJson deserializes event', () {
      final json = {
        'name': 'From JSON',
        'time': '2024-06-15T10:00:00.000Z',
        'calendarId': 'cal1',
        'color': Colors.red.toARGB32(),
        'shape': 'rectangle',
      };

      final event = Event.fromJson(json);

      expect(event.name, 'From JSON');
      expect(event.calendarId, 'cal1');
      expect(event.shape, BoxShape.rectangle);
    });

    test('JSON roundtrip preserves event', () {
      final original = Event(
        name: 'Roundtrip',
        time: DateTime.utc(2024, 6, 15, 14, 30),
        calendarId: 'cal1',
        atendees: ['user1'],
        color: Colors.green,
        shape: BoxShape.rectangle,
      );

      final json = original.toJson();
      final restored = Event.fromJson(json);

      expect(restored.name, original.name);
      expect(restored.calendarId, original.calendarId);
      expect(restored.color.value, original.color.value);
      expect(restored.shape, original.shape);
    });
  });

  group('EventX extension', () {
    test('dbgOutput returns formatted string', () {
      final event = Event(
        name: 'Debug Event',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
        color: Colors.blue,
        shape: BoxShape.circle,
      );

      final output = event.dbgOutput();

      expect(output.contains('Debug Event'), true);
      expect(output.contains('cal1'), true);
    });
  });
}
