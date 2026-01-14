// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';

/// Screen shown after registration while waiting for email verification.
class EmailVerificationPendingScreen extends ConsumerStatefulWidget {
  const EmailVerificationPendingScreen({super.key});

  @override
  ConsumerState<EmailVerificationPendingScreen> createState() =>
      _EmailVerificationPendingScreenState();
}

class _EmailVerificationPendingScreenState
    extends ConsumerState<EmailVerificationPendingScreen> {
  bool _isResending = false;
  bool _resendSuccess = false;
  DateTime? _lastResendTime;

  bool get _canResend {
    if (_lastResendTime == null) return true;
    return DateTime.now().difference(_lastResendTime!) >
        const Duration(seconds: 60);
  }

  int get _secondsUntilResend {
    if (_lastResendTime == null) return 0;
    final elapsed = DateTime.now().difference(_lastResendTime!).inSeconds;
    return (60 - elapsed).clamp(0, 60);
  }

  Future<void> _resendEmail() async {
    if (!_canResend || _isResending) return;

    final email = ref.read(pendingVerificationEmailProvider);
    if (email == null) return;

    setState(() {
      _isResending = true;
      _resendSuccess = false;
    });

    try {
      await ref.read(resendVerificationEmailProvider)(email);
      _lastResendTime = DateTime.now();
      setState(() {
        _resendSuccess = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  void _useAnotherEmail() {
    ref.read(cancelPendingVerificationProvider)();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final email = ref.watch(pendingVerificationEmailProvider) ?? '';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primaryContainer,
                  ),
                  child: Icon(
                    Icons.mark_email_unread_outlined,
                    size: 50,
                    color: theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  'Check your email',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  'We sent a verification link to',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Email address
                Text(
                  email,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Click the link in your email to verify your account.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Success message
                if (_resendSuccess) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Verification email sent!',
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Resend button
                OutlinedButton.icon(
                  onPressed: _canResend && !_isResending ? _resendEmail : null,
                  icon: _isResending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label: Text(_canResend
                      ? 'Resend verification email'
                      : 'Resend available in ${_secondsUntilResend}s'),
                ),

                const SizedBox(height: 16),

                // Use another email
                TextButton(
                  onPressed: _useAnotherEmail,
                  child: const Text('Use a different email'),
                ),

                const SizedBox(height: 32),

                // Already verified hint
                Text(
                  'Already verified?',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: _useAnotherEmail,
                  child: const Text('Sign in'),
                ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
