import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/providers/user/user_providers.dart';

/// The '/login' page.
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRepo = ref.watch(userRepositoryProvider);

    return SignInScreen(
      showAuthActionSwitch: true,
      headerBuilder: (context, constraints, shrinkOffset) {
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/timeshareimg.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.calendar_month,
                        size: 60,
                        color: Theme.of(context).colorScheme.primary,
                      );
                    },
                  ),
                ),
              ),

              // const SizedBox(height: 24),

              // App Name
              Text(
                'TimeShare',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      },
      subtitleBuilder: (context, action) {
        final isSignIn = action == AuthAction.signIn;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            isSignIn
                ? 'Sign in to access your calendars and events'
                : 'Create an account to start sharing your calendar',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        );
      },
      footerBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            'By continuing, you agree to our Terms of Service and Privacy Policy',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        );
      },
      providers: [EmailAuthProvider()],
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) async {
          await userRepo.signInOrRegister();
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }),

        AuthStateChangeAction<UserCreated>((context, state) async {
          await userRepo.signInOrRegister();
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }),
      ],
    );
  }
}
