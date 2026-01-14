// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Returns true on iOS or macOS (Apple platforms use Cupertino style)
bool get isApplePlatform {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
}

/// Returns true for Material platforms (Android, Windows, Linux, Web)
bool get isMaterialPlatform => !isApplePlatform;
