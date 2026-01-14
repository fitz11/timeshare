// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';
import 'package:timeshare/data/repo/rest_api_repo.dart';
import 'package:timeshare/data/repo/logged_calendar_repo.dart';
import 'package:timeshare/data/services/api_client.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/config/config_providers.dart';
import 'package:timeshare/services/logging/app_logger.dart';

/// AppLogger provider - enables DI and easier testing
final appLoggerProvider = Provider<AppLogger>((ref) => AppLogger());

/// Repository provider with logging wrapper - uses REST API
final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  final authService = ref.watch(authServiceProvider);
  final apiClient = HttpApiClient(
    baseUrl: config.apiBaseUrl,
    getApiKey: () => authService.apiKey,
  );
  return LoggedCalendarRepository(
    RestApiRepository(client: apiClient),
    ref.watch(appLoggerProvider),
  );
});
