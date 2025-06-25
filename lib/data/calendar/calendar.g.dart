// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Calendar _$CalendarFromJson(Map<String, dynamic> json) => _Calendar(
  id: json['id'] as String,
  owner: json['owner'] as String,
  sharedWith:
      (json['sharedWith'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  name: json['name'] as String,
  events: (json['events'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      DateTime.parse(k),
      (e as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
);

Map<String, dynamic> _$CalendarToJson(_Calendar instance) => <String, dynamic>{
  'id': instance.id,
  'owner': instance.owner,
  'sharedWith': instance.sharedWith,
  'name': instance.name,
  'events': instance.events.map((k, e) => MapEntry(k.toIso8601String(), e)),
};
