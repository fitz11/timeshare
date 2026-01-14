// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/config/app_config.dart';

/// Provides the application configuration based on the runtime environment.
final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.fromEnvironment());
