// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Calendar _$CalendarFromJson(Map<String, dynamic> json) => _Calendar(
  id: json['id'] as String,
  owner: json['owner'] as String,
  sharedWith:
      json['sharedWith'] == null
          ? const {}
          : const SetConverter().fromJson(json['sharedWith'] as List),
  name: json['name'] as String,
  events:
      json['events'] == null
          ? const {}
          : const EventMapLoader().fromJson(
            json['events'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$CalendarToJson(_Calendar instance) => <String, dynamic>{
  'id': instance.id,
  'owner': instance.owner,
  'sharedWith': const SetConverter().toJson(instance.sharedWith),
  'name': instance.name,
  'events': const EventMapLoader().toJson(instance.events),
};
