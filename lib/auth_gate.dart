// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/services/auth_service.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/services/logging/app_logger.dart';
import 'package:timeshare/ui/shell/home_scaffold.dart';
import 'package:timeshare/ui/features/auth/auth_screen.dart';
import 'package:timeshare/ui/features/auth/email_verification_pending_screen.dart';

/// Authentication gate - shows appropriate screen based on auth state.
///
/// On first load, attempts to restore stored credentials.
/// Reacts to auth state changes from the auth service.
class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  static const _tag = 'AuthGate';
  final _logger = AppLogger();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _logger.debug('Initializing auth', tag: _tag);

    // CRITICAL: First, ensure the auth state stream subscription exists
    // by reading the provider. This must happen BEFORE loadStoredCredentials()
    // emits to the broadcast stream, otherwise the emission is lost.
    ref.read(authStateProvider);

    // Now load stored credentials - the stream emission will be received
    final authService = ref.read(authServiceProvider);
    await authService.loadStoredCredentials();

    if (mounted) {
      setState(() {
        _initialized = true;
      });
      _logger.debug('Auth initialized', tag: _tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStateAsync = ref.watch(authStateProvider);

    return authStateAsync.when(
      data: (state) {
        // Still initializing
        if (!_initialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        _logger.debug('Auth state: $state', tag: _tag);

        switch (state) {
          case AuthState.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case AuthState.authenticated:
            return const HomeScaffold();
          case AuthState.pendingVerification:
            return const EmailVerificationPendingScreen();
          case AuthState.unauthenticated:
            return const AuthScreen();
          case AuthState.error:
            return const AuthScreen();
        }
      },
      loading: () {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stack) {
        _logger.error('Auth state error', error: error, stackTrace: stack, tag: _tag);
        return const AuthScreen();
      },
    );
  }
}
