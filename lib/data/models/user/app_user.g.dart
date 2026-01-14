// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  photoUrl: json['photoUrl'] as String?,
  isAdmin: json['isAdmin'] as bool? ?? false,
  joinedAt: fromTimestamp(json['dateJoined']),
  friends:
      (json['friends'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'displayName': instance.displayName,
  'photoUrl': instance.photoUrl,
  'isAdmin': instance.isAdmin,
  'dateJoined': toTimestamp(instance.joinedAt),
  'friends': instance.friends,
};
