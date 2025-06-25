import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers.dart';

///the '/login' route.
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRepo = ref.watch(userRepositoryProvider);
    return SignInScreen(
      showAuthActionSwitch: true,
      headerBuilder: (context, constraints, shrinkOffset) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Welcome to TimeShare!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
      subtitleBuilder: (context, action) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Sign in to sync your events across devices."),
          ),
        );
      },
      footerBuilder: (context, action) {
        return const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            "By signing in, you agree to our Terms of Service. Hint: There are none.",
          ),
        );
      },
      providers: [EmailAuthProvider()],
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) async {
          userRepo.createUserIfNeeded();
          Navigator.pushReplacementNamed(context, '/home');
        }),

        AuthStateChangeAction<UserCreated>((context, state) async {
          userRepo.createUserIfNeeded();
          Navigator.pushReplacementNamed(context, '/home');
        }),
      ],
    );
  }
}
