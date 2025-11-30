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

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeshare/data/models/event/event.dart';

class EventMapLoader
    implements JsonConverter<Map<DateTime, List<Event>>, Map<String, dynamic>> {
  const EventMapLoader();

  @override
  Map<DateTime, List<Event>> fromJson(Map<String, dynamic> json) {
    return json.map((key, value) {
      final date = DateTime.parse(key);
      final events = (value as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList();
      return MapEntry(date, events);
    });
  }

  @override
  Map<String, dynamic> toJson(Map<DateTime, List<Event>> map) {
    return map.map((date, events) {
      final key = date.toIso8601String();
      final value = events.map((e) => e.toJson()).toList();
      return MapEntry(key, value);
    });
  }
}

Map<String, dynamic> eventMapToJson(Map<DateTime, List<Event>> json) {
  return json.map(
    (key, value) =>
        MapEntry(key.toIso8601String(), value.map((e) => e.toJson()).toList()),
  );
}

Map<DateTime, List<Event>> eventMapFromJson(Map<String, dynamic> json) {
  return json.map(
    (key, value) => MapEntry(
      DateTime.parse(key),
      (value as List).map((e) => Event.fromJson(e)).toList(),
    ),
  );
}
