// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeshare/data/services/auth_service.dart';
import 'package:timeshare/data/services/rest_api_auth_service.dart';
import 'package:timeshare/data/services/flutter_secure_storage_impl.dart';
import 'package:timeshare/providers/config/config_providers.dart';

part 'auth_providers.g.dart';

/// Auth service provider - creates RestApiAuthService with secure storage.
/// This is the main authentication service for the app.
@riverpod
AuthService authService(Ref ref) {
  final config = ref.watch(appConfigProvider);
  return RestApiAuthService(
    baseUrl: config.apiBaseUrl,
    storage: FlutterSecureStorageImpl(),
  );
}

/// Stream of authentication state changes.
/// Use this to react to login/logout events.
@riverpod
Stream<AuthState> authState(Ref ref) =>
    ref.watch(authServiceProvider).authStateStream;

/// Current user ID - synchronous access to the current user's UID.
/// Returns null if not logged in.
@riverpod
String? currentUserId(Ref ref) => ref.watch(authServiceProvider).currentUserId;

/// Sign out the current user.
/// Revokes the API key server-side and clears stored credentials.
@riverpod
Future<void> Function() signOut(Ref ref) {
  return () => ref.read(authServiceProvider).logout();
}
