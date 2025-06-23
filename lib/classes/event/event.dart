import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeshare/classes/color_converter.dart';
//it is a dependency, don't let dartls lie to you
import 'package:intl/intl.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
abstract class Event with _$Event {
  factory Event({
    required String title,
    required DateTime time,
    List<String>? atendees,
    @ColorConverter() @Default(Colors.black) Color color,
    @Default(BoxShape.circle) BoxShape shape,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

extension EventX on Event {
  String dbgOutput() {
    return "$title: ${DateFormat.yMMMd().format(time)} : ${color.toARGB32()} : ${shape.toString()}\n";
  }
}
