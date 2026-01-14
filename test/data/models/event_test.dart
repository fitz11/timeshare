import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/models/event/event_recurrence.dart';

void main() {
  group('Event', () {
    test('creates event with required fields', () {
      final event = Event(
        id: 'event-1',
        name: 'Test Event',
        time: DateTime.utc(2024, 6, 15, 10, 0),
      );

      expect(event.id, 'event-1');
      expect(event.name, 'Test Event');
      expect(event.time, DateTime.utc(2024, 6, 15, 10, 0));
    });

    test('creates event with all fields', () {
      final event = Event(
        id: 'event-2',
        name: 'Full Event',
        time: DateTime.utc(2024, 6, 15, 14, 30),
        attendees: ['user1', 'user2'],
        color: Colors.red,
        shape: BoxShape.rectangle,
        recurrence: EventRecurrence.weekly,
        recurrenceEndDate: DateTime.utc(2024, 12, 31),
      );

      expect(event.name, 'Full Event');
      expect(event.attendees, ['user1', 'user2']);
      expect(event.color, Colors.red);
      expect(event.shape, BoxShape.rectangle);
      expect(event.recurrence, EventRecurrence.weekly);
      expect(event.recurrenceEndDate, DateTime.utc(2024, 12, 31));
    });

    test('has default color of black', () {
      final event = Event(
        id: 'event-3',
        name: 'Default Color',
        time: DateTime.utc(2024, 6, 15),
      );

      expect(event.color, Colors.black);
    });

    test('has default shape of circle', () {
      final event = Event(
        id: 'event-4',
        name: 'Default Shape',
        time: DateTime.utc(2024, 6, 15),
      );

      expect(event.shape, BoxShape.circle);
    });

    test('has default recurrence of none', () {
      final event = Event(
        id: 'event-5',
        name: 'Default Recurrence',
        time: DateTime.utc(2024, 6, 15),
      );

      expect(event.recurrence, EventRecurrence.none);
      expect(event.recurrenceEndDate, isNull);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = Event(
        id: 'event-6',
        name: 'Original',
        time: DateTime.utc(2024, 6, 15),
        color: Colors.blue,
      );

      final copied = original.copyWith(name: 'Copied');

      expect(copied.name, 'Copied');
      expect(copied.time, original.time);
      expect(copied.id, original.id);
      expect(copied.color, original.color);
    });

    test('copyWith preserves original when no changes', () {
      final original = Event(
        id: 'event-7',
        name: 'Original',
        time: DateTime.utc(2024, 6, 15),
      );

      final copied = original.copyWith();

      expect(copied.name, original.name);
      expect(copied.time, original.time);
      expect(copied.id, original.id);
    });

    test('equality works correctly', () {
      final event1 = Event(
        id: 'event-8',
        name: 'Same Event',
        time: DateTime.utc(2024, 6, 15, 10, 0),
        color: Colors.blue,
      );

      final event2 = Event(
        id: 'event-8',
        name: 'Same Event',
        time: DateTime.utc(2024, 6, 15, 10, 0),
        color: Colors.blue,
      );

      expect(event1, event2);
    });

    test('inequality for different names', () {
      final event1 = Event(
        id: 'event-9',
        name: 'Event 1',
        time: DateTime.utc(2024, 6, 15),
      );

      final event2 = Event(
        id: 'event-10',
        name: 'Event 2',
        time: DateTime.utc(2024, 6, 15),
      );

      expect(event1, isNot(event2));
    });

    test('toJson serializes event', () {
      final event = Event(
        id: 'event-11',
        name: 'JSON Event',
        time: DateTime.utc(2024, 6, 15, 10, 0),
        color: Colors.blue,
        shape: BoxShape.circle,
      );

      final json = event.toJson();

      expect(json['id'], 'event-11');
      expect(json['name'], 'JSON Event');
      expect(json['shape'], 'circle');
      expect(json['recurrence'], 'none');
    });

    test('fromJson deserializes event', () {
      final json = {
        'id': 'event-12',
        'name': 'From JSON',
        'time': '2024-06-15T10:00:00.000Z',
        'color': Colors.red.toARGB32(),
        'shape': 'rectangle',
        'recurrence': 'weekly',
      };

      final event = Event.fromJson(json);

      expect(event.id, 'event-12');
      expect(event.name, 'From JSON');
      expect(event.shape, BoxShape.rectangle);
      expect(event.recurrence, EventRecurrence.weekly);
    });

    test('JSON roundtrip preserves event', () {
      final original = Event(
        id: 'event-13',
        name: 'Roundtrip',
        time: DateTime.utc(2024, 6, 15, 14, 30),
        attendees: ['user1'],
        color: Colors.green,
        shape: BoxShape.rectangle,
        recurrence: EventRecurrence.monthly,
      );

      final json = original.toJson();
      final restored = Event.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.color.toARGB32(), original.color.toARGB32());
      expect(restored.shape, original.shape);
      expect(restored.recurrence, original.recurrence);
    });
  });

  group('EventX extension', () {
    test('dbgOutput returns formatted string', () {
      final event = Event(
        id: 'event-14',
        name: 'Debug Event',
        time: DateTime.utc(2024, 6, 15),
        color: Colors.blue,
        shape: BoxShape.circle,
      );

      final output = event.dbgOutput();

      expect(output.contains('Debug Event'), true);
    });
  });
}
