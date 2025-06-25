// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
  name: json['name'] as String,
  time: DateTime.parse(json['time'] as String),
  atendees:
      (json['atendees'] as List<dynamic>?)?.map((e) => e as String).toList(),
  color:
      json['color'] == null
          ? Colors.black
          : const ColorConverter().fromJson((json['color'] as num).toInt()),
  shape:
      $enumDecodeNullable(_$BoxShapeEnumMap, json['shape']) ?? BoxShape.circle,
);

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
  'name': instance.name,
  'time': instance.time.toIso8601String(),
  'atendees': instance.atendees,
  'color': const ColorConverter().toJson(instance.color),
  'shape': _$BoxShapeEnumMap[instance.shape]!,
};

const _$BoxShapeEnumMap = {
  BoxShape.rectangle: 'rectangle',
  BoxShape.circle: 'circle',
};
