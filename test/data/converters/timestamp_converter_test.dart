import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/converters/timestamp_converter.dart';

void main() {
  group('fromTimestamp', () {
    test('returns DateTime when given a DateTime', () {
      final dateTime = DateTime(2024, 6, 15, 10, 30);
      final result = fromTimestamp(dateTime);
      expect(result, dateTime);
    });

    test('converts Timestamp to DateTime', () {
      final timestamp = Timestamp.fromDate(DateTime(2024, 6, 15, 10, 30));
      final result = fromTimestamp(timestamp);
      expect(result.year, 2024);
      expect(result.month, 6);
      expect(result.day, 15);
    });

    test('throws exception for invalid input', () {
      expect(() => fromTimestamp('invalid'), throwsException);
    });

    test('throws exception for null', () {
      expect(() => fromTimestamp(null), throwsException);
    });

    test('throws exception for int', () {
      expect(() => fromTimestamp(12345), throwsException);
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
