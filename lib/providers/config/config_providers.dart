// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeshare/config/app_config.dart';

part 'config_providers.g.dart';

/// Provides the application configuration based on the runtime environment.
@riverpod
AppConfig appConfig(Ref ref) => AppConfig.fromEnvironment();
