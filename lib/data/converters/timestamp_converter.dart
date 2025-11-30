// Timeshare: a cross-platform app to make and share calendars.
// Copyright (C) 2025  David Fitzsimmons
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
