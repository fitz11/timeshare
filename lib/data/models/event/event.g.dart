// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
  id: json['id'] as String,
  name: json['name'] as String,
  time: DateTime.parse(json['time'] as String),
  atendees: (json['atendees'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  color: json['color'] == null
      ? Colors.black
      : const ColorConverter().fromJson((json['color'] as num).toInt()),
  shape: json['shape'] == null
      ? BoxShape.circle
      : const ShapeConverter().fromJson(json['shape'] as String),
  recurrence:
      $enumDecodeNullable(_$EventRecurrenceEnumMap, json['recurrence']) ??
      EventRecurrence.none,
  recurrenceEndDate: json['recurrenceEndDate'] == null
      ? null
      : DateTime.parse(json['recurrenceEndDate'] as String),
  version: (json['version'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'time': instance.time.toIso8601String(),
  'atendees': instance.atendees,
  'color': const ColorConverter().toJson(instance.color),
  'shape': const ShapeConverter().toJson(instance.shape),
  'recurrence': _$EventRecurrenceEnumMap[instance.recurrence]!,
  'recurrenceEndDate': instance.recurrenceEndDate?.toIso8601String(),
  'version': instance.version,
};

const _$EventRecurrenceEnumMap = {
  EventRecurrence.none: 'none',
  EventRecurrence.daily: 'daily',
  EventRecurrence.weekly: 'weekly',
  EventRecurrence.monthly: 'monthly',
  EventRecurrence.yearly: 'yearly',
};
