// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Returns true on iOS or macOS (Apple platforms use Cupertino style)
bool get isApplePlatform {
  if (kIsWeb) return false;
  return Platform.isIOS || Platform.isMacOS;
}

/// Returns true for Material platforms (Android, Windows, Linux, Web)
bool get isMaterialPlatform => !isApplePlatform;
