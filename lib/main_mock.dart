// SPDX-License-Identifier: AGPL-3.0-or-later

// Mock entry point for development without a real backend.
//
// Run with: flutter run -t lib/main_mock.dart
//
// This creates a fully functional app with mock data, allowing you to:
// - Test the UI without a backend connection
// - Develop new features offline
// - Debug UI issues in isolation

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/auth_gate.dart';
import 'package:timeshare/data/repo/rest_api_repo.dart';
import 'package:timeshare/data/repo/rest_api_user_repo.dart';
import 'package:timeshare/data/repo/rest_api_friend_request_repo.dart';
import 'package:timeshare/data/repo/rest_api_ownership_transfer_repo.dart';
import 'package:timeshare/data/repo/logged_calendar_repo.dart';
import 'package:timeshare/data/repo/logged_user_repo.dart';
import 'package:timeshare/data/repo/logged_friend_request_repo.dart';
import 'package:timeshare/data/repo/logged_ownership_transfer_repo.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/providers/user/user_providers.dart';
import 'package:timeshare/providers/friend_request/friend_request_providers.dart';
import 'package:timeshare/providers/ownership_transfer/ownership_transfer_providers.dart';
import 'package:timeshare/services/logging/app_logger.dart';
import 'package:timeshare/ui/shell/home_scaffold.dart';
import 'package:timeshare/ui/features/auth/auth_screen.dart';
import 'package:timeshare/ui/core/theme/themes.dart';

import 'dev/mock_services.dart';
import 'dev/mock_data.dart';

void main() async {
  print('=== MAIN_MOCK STARTING ===');

  print('[main_mock] Initializing Flutter binding...');
  WidgetsFlutterBinding.ensureInitialized();
  print('[main_mock] Flutter binding initialized');

  // Initialize the app logger
  print('[main_mock] Initializing AppLogger...');
  await AppLogger().initialize();
  print('[main_mock] AppLogger initialized');

  // Create mock services
  print('[main_mock] Creating MockAuthService...');
  final mockAuth = MockAuthService();
  print('[main_mock] MockAuthService created');

  print('[main_mock] Creating MockApiClient...');
  final mockApiClient = MockApiClient();
  print('[main_mock] MockApiClient created');

  // Pre-authenticate so we skip the login screen
  print('[main_mock] Setting mock user (pre-auth)...');
  mockAuth.setMockUser(
    userId: MockData.mockUserId,
    apiKey: MockData.mockApiKey,
  );
  print('[main_mock] Mock user set - userId: ${MockData.mockUserId}');

  // Seed with sample data
  print('[main_mock] Seeding mock API client with data...');
  seedMockApiClient(mockApiClient);
  print('[main_mock] Mock API client seeded');

  // Create repositories using mock client
  print('[main_mock] Creating RestApiRepository...');
  final calendarRepo = RestApiRepository(client: mockApiClient);
  print('[main_mock] RestApiRepository created');

  print('[main_mock] Creating RestApiUserRepository...');
  final userRepo = RestApiUserRepository(
    client: mockApiClient,
    authService: mockAuth,
    calendarRepo: calendarRepo,
  );
  print('[main_mock] RestApiUserRepository created');

  print('[main_mock] Creating RestApiFriendRequestRepository...');
  final friendRequestRepo = RestApiFriendRequestRepository(client: mockApiClient);
  print('[main_mock] RestApiFriendRequestRepository created');

  print('[main_mock] Creating RestApiOwnershipTransferRepository...');
  final ownershipTransferRepo = RestApiOwnershipTransferRepository(client: mockApiClient);
  print('[main_mock] RestApiOwnershipTransferRepository created');

  final logger = AppLogger();

  print('[main_mock] Creating ProviderScope with overrides...');
  print('[main_mock] - authServiceProvider override');
  print('[main_mock] - calendarRepositoryProvider override');
  print('[main_mock] - userRepositoryProvider override');
  print('[main_mock] - friendRequestRepositoryProvider override');
  print('[main_mock] - ownershipTransferRepositoryProvider override');

  print('[main_mock] Calling runApp()...');
  runApp(
    ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuth),
        calendarRepositoryProvider.overrideWithValue(
          LoggedCalendarRepository(calendarRepo, logger),
        ),
        userRepositoryProvider.overrideWithValue(
          LoggedUserRepository(userRepo, logger),
        ),
        friendRequestRepositoryProvider.overrideWithValue(
          LoggedFriendRequestRepository(friendRequestRepo, logger),
        ),
        ownershipTransferRepositoryProvider.overrideWithValue(
          LoggedOwnershipTransferRepository(ownershipTransferRepo, logger),
        ),
      ],
      child: const TimeshareMock(),
    ),
  );
  print('[main_mock] runApp() called - app should be running');
}

class TimeshareMock extends ConsumerWidget {
  const TimeshareMock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('[TimeshareMock] build() called');
    print('[TimeshareMock] Creating MaterialApp with AuthGate as home...');
    return MaterialApp(
      title: 'TimeShare (Mock)',
      debugShowCheckedModeBanner: true, // Keep banner to indicate mock mode
      theme: buildTheme(lightColorScheme, Brightness.light),
      darkTheme: buildTheme(darkColorScheme, Brightness.dark),
      themeMode: ThemeMode.system,
      routes: {
        '/home': (context) {
          print('[TimeshareMock] Navigating to /home route');
          return const HomeScaffold();
        },
        '/login': (context) {
          print('[TimeshareMock] Navigating to /login route');
          return const AuthScreen();
        },
      },
      home: const AuthGate(),
    );
  }
}
