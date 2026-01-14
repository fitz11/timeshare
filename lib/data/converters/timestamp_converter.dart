// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:timeshare/data/models/event/event.dart';

/// Convert a value to DateTime.
/// Handles DateTime objects and ISO 8601 strings.
/// Returns Unix epoch (1970-01-01) if value is null or invalid type.
DateTime fromTimestamp(dynamic value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.parse(value);
  // Return epoch for null/invalid - prevents crashes on malformed API responses
  return DateTime.utc(1970, 1, 1);
}

/// Convert DateTime to UTC for storage.
DateTime toTimestamp(DateTime date) => date.toUtc();

/// Convert event map to JSON.
Map<String, dynamic> eventMapToJson(Map<DateTime, List<Event>> map) {
  return map.map(
    (key, value) =>
        MapEntry(key.toIso8601String(), value.map((e) => e.toJson()).toList()),
  );
}

/// Convert JSON to event map.
Map<DateTime, List<Event>> eventMapFromJson(Map<String, dynamic> map) {
  return map.map(
    (key, value) => MapEntry(
      DateTime.parse(key),
      (value as List).map((e) => Event.fromJson(e)).toList(),
    ),
  );
}
