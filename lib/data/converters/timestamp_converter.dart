import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeshare/data/models/event/event.dart';

DateTime fromTimestamp(dynamic value) {
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  throw Exception('invalid timestamp: $value');
}

DateTime toTimestamp(DateTime date) => date.toUtc();

Map<String, dynamic> eventMapToJson(Map<DateTime, List<Event>> map) {
  return map.map(
    (key, value) =>
        MapEntry(key.toIso8601String(), value.map((e) => e.toJson()).toList()),
  );
}

Map<DateTime, List<Event>> eventMapFromJson(Map<String, dynamic> map) {
  return map.map(
    (key, value) => MapEntry(
      DateTime.parse(key),
      (value as List).map((e) => Event.fromJson(e)).toList(),
    ),
  );
}
