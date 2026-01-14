// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/services/auth_service.dart';
import 'package:timeshare/data/services/rest_api_auth_service.dart';
import 'package:timeshare/data/services/flutter_secure_storage_impl.dart';
import 'package:timeshare/providers/config/config_providers.dart';
import 'package:timeshare/services/logging/app_logger.dart';

final _logger = AppLogger();
const _tag = 'AuthProviders';

/// Auth service provider - creates RestApiAuthService with secure storage.
final authServiceProvider = Provider<AuthService>((ref) {
  final config = ref.watch(appConfigProvider);
  _logger.debug('Creating auth service for ${config.apiBaseUrl}', tag: _tag);
  final service = RestApiAuthService(
    baseUrl: config.apiBaseUrl,
    storage: FlutterSecureStorageImpl(),
  );
  ref.onDispose(() => service.dispose());
  return service;
});

/// Stream of authentication state changes.
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateStream;
});

/// Current user ID - synchronous access to the current user's UID.
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authServiceProvider).currentUserId;
});

/// Sign out the current user.
final signOutProvider = Provider<Future<void> Function()>((ref) {
  return () => ref.read(authServiceProvider).logout();
});

/// Change the current user's password.
final changePasswordProvider =
    Provider<Future<void> Function(String currentPassword, String newPassword)>((ref) {
  return (currentPassword, newPassword) =>
      ref.read(authServiceProvider).changePassword(currentPassword, newPassword);
});

/// Change the current user's email address.
final changeEmailProvider =
    Provider<Future<void> Function(String newEmail, String password)>((ref) {
  return (newEmail, password) =>
      ref.read(authServiceProvider).changeEmail(newEmail, password);
});

/// Request a password reset email.
final requestPasswordResetProvider =
    Provider<Future<void> Function(String email)>((ref) {
  return (email) => ref.read(authServiceProvider).requestPasswordReset(email);
});

/// Email pending verification - the email that needs to be verified.
final pendingVerificationEmailProvider = Provider<String?>((ref) =>
    ref.watch(authServiceProvider).pendingVerificationEmail);

/// Verify email with a token.
final verifyEmailProvider =
    Provider<Future<String> Function(String token)>((ref) {
  return (token) => ref.read(authServiceProvider).verifyEmail(token);
});

/// Resend verification email.
final resendVerificationEmailProvider =
    Provider<Future<void> Function(String email)>((ref) {
  return (email) =>
      ref.read(authServiceProvider).resendVerificationEmail(email);
});

/// Cancel pending verification and return to unauthenticated state.
final cancelPendingVerificationProvider = Provider<void Function()>((ref) {
  return () => ref.read(authServiceProvider).cancelPendingVerification();
});
