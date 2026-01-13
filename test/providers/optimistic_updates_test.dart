// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/exceptions/conflict_exception.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';

void main() {
  group('ConflictException', () {
    test('stores local and server versions', () {
      final exception = ConflictException(
        message: 'Event was modified',
        localVersion: 1,
        serverVersion: 3,
      );

      expect(exception.localVersion, equals(1));
      expect(exception.serverVersion, equals(3));
      expect(exception.message, contains('modified'));
    });

    test('stores server data for retry', () {
      final serverEvent = Event(
        id: 'event-1',
        name: 'Updated Event',
        time: DateTime.now(),
        version: 3,
      );

      final exception = ConflictException(
        message: 'Event was modified',
        localVersion: 1,
        serverVersion: 3,
        serverData: serverEvent,
      );

      expect(exception.serverData, isA<Event>());
      expect((exception.serverData as Event).name, equals('Updated Event'));
      expect((exception.serverData as Event).version, equals(3));
    });

    test('toString includes version info', () {
      final exception = ConflictException(
        message: 'Event was modified',
        localVersion: 1,
        serverVersion: 3,
      );

      final str = exception.toString();
      expect(str, contains('v1'));
      expect(str, contains('v3'));
    });
  });

  group('Version field', () {
    test('Calendar has default version of 1', () {
      final calendar = Calendar(
        id: 'cal-1',
        owner: 'user-1',
        name: 'Test Calendar',
      );

      expect(calendar.version, equals(1));
    });

    test('Calendar can be created with custom version', () {
      final calendar = Calendar(
        id: 'cal-1',
        owner: 'user-1',
        name: 'Test Calendar',
        version: 5,
      );

      expect(calendar.version, equals(5));
    });

    test('Calendar version is included in JSON', () {
      final calendar = Calendar(
        id: 'cal-1',
        owner: 'user-1',
        name: 'Test Calendar',
        version: 3,
      );

      final json = calendar.toJson();
      expect(json['version'], equals(3));
    });

    test('Calendar version is parsed from JSON', () {
      final json = {
        'id': 'cal-1',
        'owner': 'user-1',
        'name': 'Test Calendar',
        'version': 5,
      };

      final calendar = Calendar.fromJson(json);
      expect(calendar.version, equals(5));
    });

    test('Event has default version of 1', () {
      final event = Event(
        id: 'event-1',
        name: 'Test Event',
        time: DateTime.now(),
      );

      expect(event.version, equals(1));
    });

    test('Event can be created with custom version', () {
      final event = Event(
        id: 'event-1',
        name: 'Test Event',
        time: DateTime.now(),
        version: 7,
      );

      expect(event.version, equals(7));
    });

    test('Event version is included in JSON', () {
      final event = Event(
        id: 'event-1',
        name: 'Test Event',
        time: DateTime.now(),
        version: 4,
      );

      final json = event.toJson();
      expect(json['version'], equals(4));
    });

    test('Event version is parsed from JSON', () {
      final json = {
        'id': 'event-1',
        'name': 'Test Event',
        'time': DateTime.now().toIso8601String(),
        'version': 6,
      };

      final event = Event.fromJson(json);
      expect(event.version, equals(6));
    });
  });

  group('Version copyWith', () {
    test('Calendar copyWith preserves version', () {
      final calendar = Calendar(
        id: 'cal-1',
        owner: 'user-1',
        name: 'Test Calendar',
        version: 5,
      );

      final updated = calendar.copyWith(name: 'New Name');
      expect(updated.version, equals(5));
    });

    test('Calendar copyWith can update version', () {
      final calendar = Calendar(
        id: 'cal-1',
        owner: 'user-1',
        name: 'Test Calendar',
        version: 5,
      );

      final updated = calendar.copyWith(version: 6);
      expect(updated.version, equals(6));
    });

    test('Event copyWith preserves version', () {
      final event = Event(
        id: 'event-1',
        name: 'Test Event',
        time: DateTime.now(),
        version: 3,
      );

      final updated = event.copyWith(name: 'New Event Name');
      expect(updated.version, equals(3));
    });

    test('Event copyWith can update version', () {
      final event = Event(
        id: 'event-1',
        name: 'Test Event',
        time: DateTime.now(),
        version: 3,
      );

      final updated = event.copyWith(version: 4);
      expect(updated.version, equals(4));
    });
  });
}
