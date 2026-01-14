// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    _FriendRequest(
      id: json['id'] as String,
      fromUid: json['fromUser'] as String,
      toUid: json['toUser'] as String,
      status:
          $enumDecodeNullable(_$FriendRequestStatusEnumMap, json['status']) ??
          FriendRequestStatus.pending,
      createdAt: fromTimestamp(json['createdAt']),
      expiresAt: fromTimestamp(json['expiresAt']),
      fromDisplayName: json['fromDisplayName'] as String?,
      fromEmail: json['fromEmail'] as String?,
      fromPhotoUrl: json['fromPhotoUrl'] as String?,
      toDisplayName: json['toDisplayName'] as String?,
      toEmail: json['toEmail'] as String?,
      toPhotoUrl: json['toPhotoUrl'] as String?,
    );

Map<String, dynamic> _$FriendRequestToJson(_FriendRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUser': instance.fromUid,
      'toUser': instance.toUid,
      'status': _$FriendRequestStatusEnumMap[instance.status]!,
      'createdAt': toTimestamp(instance.createdAt),
      'expiresAt': toTimestamp(instance.expiresAt),
      'fromDisplayName': instance.fromDisplayName,
      'fromEmail': instance.fromEmail,
      'fromPhotoUrl': instance.fromPhotoUrl,
      'toDisplayName': instance.toDisplayName,
      'toEmail': instance.toEmail,
      'toPhotoUrl': instance.toPhotoUrl,
    };

const _$FriendRequestStatusEnumMap = {
  FriendRequestStatus.pending: 'pending',
  FriendRequestStatus.accepted: 'accepted',
  FriendRequestStatus.declined: 'declined',
};
