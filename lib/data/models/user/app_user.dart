// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeshare/data/converters/timestamp_converter.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    required String displayName,
    String? photoUrl,
    @Default(false) bool isAdmin,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp)
    required DateTime joinedAt,
    @Default([]) List<String> friends,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
