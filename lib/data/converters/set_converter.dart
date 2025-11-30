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

class SetConverter implements JsonConverter<Set<String>, List<dynamic>> {
  const SetConverter();

  @override
  Set<String> fromJson(dynamic json) {
    if (json is List) {
      return json.map((e) => e as String).toSet();
    }
    return {};
  }

  @override
  List<String> toJson(Set<String> set) => set.toList();
}
