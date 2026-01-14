// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeshare/data/converters/timestamp_converter.dart';

part 'ownership_transfer_request.freezed.dart';
part 'ownership_transfer_request.g.dart';

/// Status of an ownership transfer request.
enum TransferStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('declined')
  declined,
  @JsonValue('cancelled')
  cancelled,
}

/// A request to transfer calendar ownership from one user to another.
///
/// The recipient must accept the transfer before becoming the new owner.
@freezed
abstract class OwnershipTransferRequest with _$OwnershipTransferRequest {
  const OwnershipTransferRequest._();

  const factory OwnershipTransferRequest({
    required String id,
    @JsonKey(name: 'calendar') required String calendarId,
    required String calendarName,
    @JsonKey(name: 'fromUser') required String fromUid,
    @JsonKey(name: 'toUser') required String toUid,
    @Default(TransferStatus.pending) TransferStatus status,
    @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp)
    required DateTime createdAt,
    // Denormalized fields for display (populated by backend)
    String? fromDisplayName,
    String? fromEmail,
    String? toDisplayName,
    String? toEmail,
  }) = _OwnershipTransferRequest;

  factory OwnershipTransferRequest.fromJson(Map<String, dynamic> json) =>
      _$OwnershipTransferRequestFromJson(json);

  /// Returns true if the request is still pending.
  bool get isPending => status == TransferStatus.pending;
}
