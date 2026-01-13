// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/services/auth_service.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/ui/shell/home_scaffold.dart';
import 'package:timeshare/ui/features/auth/auth_screen.dart';

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
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    // Attempt to restore stored credentials on app startup
    final authService = ref.read(authServiceProvider);
    await authService.loadStoredCredentials();
    if (mounted) {
      setState(() {
        _initialized = true;
      });
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

        switch (state) {
          case AuthState.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case AuthState.authenticated:
            return const HomeScaffold();
          case AuthState.unauthenticated:
          case AuthState.error:
            return const AuthScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const AuthScreen(),
    );
  }
}
