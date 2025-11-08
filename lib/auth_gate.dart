import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/providers/cal/cal_providers.dart';
import 'package:timeshare/data/providers/user/user_providers.dart';
import 'package:timeshare/ui/core/home_scaffold.dart';
import 'package:timeshare/ui/pages/auth.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User logged in - initialize data providers here
        if (snapshot.hasData) {
          // Pre-initialize data providers to keep them alive
          // This prevents re-initialization when navigating away
          ref.watch(calendarsProvider);
          ref.watch(userFriendsProvider);
          
          return const HomeScaffold();
        }

        // User is NOT logged in
        return const AuthScreen();
      },
    );
  }
}
