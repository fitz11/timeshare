// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeshare/data/converters/color_converter.dart';
//it is a dependency, don't let dartls lie to you
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/data/converters/shape_converter.dart';
import 'package:timeshare/data/models/event/event_recurrence.dart';

part 'event.freezed.dart';
part 'event.g.dart';

//note: by default JSON notation for datetime will be Iso8601

@freezed
abstract class Event with _$Event {
  factory Event({
    required String id,
    required String name,
    required DateTime time,
    @Default([]) List<String> attendees,
    @ColorConverter() @Default(Colors.black) Color color,
    @ShapeConverter() @Default(BoxShape.circle) BoxShape shape,
    @Default(EventRecurrence.none) EventRecurrence recurrence,
    DateTime? recurrenceEndDate,
    // calendarId is populated at runtime from the subcollection path, not stored in backend
    @JsonKey(includeToJson: false) String? calendarId,
    @Default(1) int version,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

extension EventX on Event {
  String dbgOutput() {
    return '$name: ${DateFormat.yMMMd().format(time)} : ${color.toARGB32()} : ${shape.toString()} : $recurrence\n';
  }
}
