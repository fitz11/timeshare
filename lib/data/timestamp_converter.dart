import 'package:cloud_firestore/cloud_firestore.dart';

class TimestampConverter {
  static DateTime fromTimestamp(dynamic value) {
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    throw Exception("invalid timestamp: $value");
  }

  static DateTime toTimestamp(DateTime date) => date.toUtc();
}
