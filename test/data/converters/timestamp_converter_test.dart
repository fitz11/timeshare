// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/converters/timestamp_converter.dart';

void main() {
  group('fromTimestamp', () {
    test('returns DateTime when given a DateTime', () {
      final dateTime = DateTime(2024, 6, 15, 10, 30);
      final result = fromTimestamp(dateTime);
      expect(result, dateTime);
    });

    test('parses ISO 8601 string to DateTime', () {
      const isoString = '2024-06-15T10:30:00.000';
      final result = fromTimestamp(isoString);
      expect(result.year, 2024);
      expect(result.month, 6);
      expect(result.day, 15);
      expect(result.hour, 10);
      expect(result.minute, 30);
    });

    test('parses UTC ISO 8601 string', () {
      const isoString = '2024-06-15T10:30:00.000Z';
      final result = fromTimestamp(isoString);
      expect(result.year, 2024);
      expect(result.month, 6);
      expect(result.day, 15);
      expect(result.isUtc, true);
    });

    test('throws exception for invalid string', () {
      expect(() => fromTimestamp('invalid'), throwsException);
    });

    test('returns epoch for null', () {
      final result = fromTimestamp(null);
      expect(result, DateTime.utc(1970, 1, 1));
    });

    test('returns epoch for int', () {
      final result = fromTimestamp(12345);
      expect(result, DateTime.utc(1970, 1, 1));
    });
  });

  group('toTimestamp', () {
    test('converts DateTime to UTC', () {
      final localDate = DateTime(2024, 6, 15, 10, 30);
      final result = toTimestamp(localDate);
      expect(result.isUtc, true);
    });

    test('preserves UTC DateTime', () {
      final utcDate = DateTime.utc(2024, 6, 15, 10, 30);
      final result = toTimestamp(utcDate);
      expect(result, utcDate);
      expect(result.isUtc, true);
    });

    test('preserves date components', () {
      final date = DateTime(2024, 12, 25, 14, 45, 30);
      final result = toTimestamp(date);
      expect(result.year, 2024);
      expect(result.month, 12);
      expect(result.day, 25);
    });
  });
}
