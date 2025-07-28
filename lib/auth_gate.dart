// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/providers/auth/auth_providers.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // Not signed in
          Future.microtask(
            () => Navigator.pushReplacementNamed(context, '/login'),
          );
        } else {
          // Signed in
          Future.microtask(
            () => Navigator.pushReplacementNamed(context, '/home'),
          );
        }

        // Return something while routing happens
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}
