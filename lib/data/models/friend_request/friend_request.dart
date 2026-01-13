// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeshare/data/converters/timestamp_converter.dart';

part 'friend_request.freezed.dart';
part 'friend_request.g.dart';

/// Status of a friend request.
enum FriendRequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('declined')
  declined,
}

/// A friend request between two users.
///
/// Friend requests have a 30-day expiration period.
/// Once accepted, both users are added to each other's friends list.
@freezed
abstract class FriendRequest with _$FriendRequest {
  const FriendRequest._();

  const factory FriendRequest({
    required String id,
    required String fromUid,
    required String toUid,
    @Default(FriendRequestStatus.pending) FriendRequestStatus status,
    @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp)
    required DateTime createdAt,
    @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp)
    required DateTime expiresAt,
    // Denormalized fields for display (populated by backend)
    String? fromDisplayName,
    String? fromEmail,
    String? fromPhotoUrl,
    String? toDisplayName,
    String? toEmail,
    String? toPhotoUrl,
  }) = _FriendRequest;

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);

  /// Returns true if the request has expired.
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Returns the time remaining until expiration.
  Duration get timeUntilExpiry => expiresAt.difference(DateTime.now());

  /// Returns the number of days until expiration.
  int get daysUntilExpiry => timeUntilExpiry.inDays;

  /// Returns true if the request is still pending and not expired.
  bool get isPendingAndValid =>
      status == FriendRequestStatus.pending && !isExpired;
}
