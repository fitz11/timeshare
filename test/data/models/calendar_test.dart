// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';

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
      };

      final calendar = Calendar.fromJson(json);

      expect(calendar.id, 'cal1');
      expect(calendar.name, 'From JSON');
    });

    test('copyWith creates new instance with updated fields', () {
      final original = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Original',
      );

      final copied = original.copyWith(name: 'Copied');

      expect(copied.name, 'Copied');
      expect(copied.id, original.id);
      expect(copied.owner, original.owner);
    });

    test('equality works correctly', () {
      final cal1 = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Same',
      );

      final cal2 = Calendar(
        id: 'cal1',
        owner: 'user123',
        name: 'Same',
      );

      expect(cal1, cal2);
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
}
