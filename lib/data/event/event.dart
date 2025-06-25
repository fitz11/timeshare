import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeshare/data/color_converter.dart';
//it is a dependency, don't let dartls lie to you
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/data/shape_converter.dart';

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
    return "$name: $calendarId : ${DateFormat.yMMMd().format(time)} : ${color.toARGB32()} : ${shape.toString()}\n";
  }
}
