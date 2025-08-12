// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
  name: json['name'] as String,
  time: DateTime.parse(json['time'] as String),
  calendarId: json['calendarId'] as String,
  atendees:
      (json['atendees'] as List<dynamic>?)?.map((e) => e as String).toList(),
  color:
      json['color'] == null
          ? Colors.black
          : const ColorConverter().fromJson((json['color'] as num).toInt()),
  shape:
      json['shape'] == null
          ? BoxShape.circle
          : const ShapeConverter().fromJson(json['shape'] as String),
);

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
  'name': instance.name,
  'time': instance.time.toIso8601String(),
  'calendarId': instance.calendarId,
  'atendees': instance.atendees,
  'color': const ColorConverter().toJson(instance.color),
  'shape': const ShapeConverter().toJson(instance.shape),
};
