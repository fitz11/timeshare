// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Provider that fetches app package info (version, build number, etc.)
final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return PackageInfo.fromPlatform();
});

/// Convenience provider for the app version string.
final appVersionProvider = Provider<AsyncValue<String>>((ref) {
  return ref.watch(packageInfoProvider).whenData((info) => info.version);
});
