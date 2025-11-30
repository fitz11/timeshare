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

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeshare/data/converters/color_converter.dart';
//it is a dependency, don't let dartls lie to you
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/data/converters/shape_converter.dart';

part 'event.freezed.dart';
part 'event.g.dart';

//note: by default JSON notation for datetime will be Iso8601

@freezed
abstract class Event with _$Event {
  factory Event({
    required String name,
    required DateTime time,
    required String calendarId,
    List<String>? atendees,
    @ColorConverter() @Default(Colors.black) Color color,
    @ShapeConverter() @Default(BoxShape.circle) BoxShape shape,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

extension EventX on Event {
  String dbgOutput() {
    return '$name: $calendarId : ${DateFormat.yMMMd().format(time)} : ${color.toARGB32()} : ${shape.toString()}\n';
  }
}
