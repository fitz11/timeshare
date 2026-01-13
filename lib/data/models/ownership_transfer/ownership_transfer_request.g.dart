// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ownership_transfer_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OwnershipTransferRequest _$OwnershipTransferRequestFromJson(
  Map<String, dynamic> json,
) => _OwnershipTransferRequest(
  id: json['id'] as String,
  calendarId: json['calendarId'] as String,
  calendarName: json['calendarName'] as String,
  fromUid: json['fromUid'] as String,
  toUid: json['toUid'] as String,
  status:
      $enumDecodeNullable(_$TransferStatusEnumMap, json['status']) ??
      TransferStatus.pending,
  createdAt: fromTimestamp(json['createdAt']),
  fromDisplayName: json['fromDisplayName'] as String?,
  fromEmail: json['fromEmail'] as String?,
  toDisplayName: json['toDisplayName'] as String?,
  toEmail: json['toEmail'] as String?,
);

Map<String, dynamic> _$OwnershipTransferRequestToJson(
  _OwnershipTransferRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'calendarId': instance.calendarId,
  'calendarName': instance.calendarName,
  'fromUid': instance.fromUid,
  'toUid': instance.toUid,
  'status': _$TransferStatusEnumMap[instance.status]!,
  'createdAt': toTimestamp(instance.createdAt),
  'fromDisplayName': instance.fromDisplayName,
  'fromEmail': instance.fromEmail,
  'toDisplayName': instance.toDisplayName,
  'toEmail': instance.toEmail,
};

const _$TransferStatusEnumMap = {
  TransferStatus.pending: 'pending',
  TransferStatus.accepted: 'accepted',
  TransferStatus.declined: 'declined',
  TransferStatus.cancelled: 'cancelled',
};
