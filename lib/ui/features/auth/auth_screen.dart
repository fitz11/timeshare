// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/exceptions/email_not_verified_exception.dart';
import 'package:timeshare/data/services/rest_api_auth_service.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';

/// Authentication screen - login and registration.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);

      if (_isLogin) {
        await authService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        await authService.signup(
          _emailController.text.trim(),
          _passwordController.text,
          _displayNameController.text.trim(),
        );
      }
      // Navigation handled by AuthGate reacting to auth state change
    } on EmailNotVerifiedException catch (e) {
      if (mounted) {
        _showEmailNotVerifiedDialog(e.email, fromSignup: !_isLogin);
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e, stackTrace) {
      // Log the actual error type and message for debugging
      debugPrint('Auth error (${e.runtimeType}): $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        // Show more detail to help diagnose production issues
        _errorMessage = 'Error: ${e.runtimeType}. Please try again or contact support.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showEmailNotVerifiedDialog(String email, {bool fromSignup = false}) {
    showDialog(
      context: context,
      builder: (context) => _EmailNotVerifiedDialog(
        ref: ref,
        email: email,
        fromSignup: fromSignup,
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;
    });
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController(text: _emailController.text);

    showDialog(
      context: context,
      builder: (context) => _ForgotPasswordDialog(
        ref: ref,
        emailController: emailController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/timeshareimg.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.calendar_month,
                                    size: 60,
                                    color: theme.colorScheme.primary,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                  // App Name
                  Text(
                    'TimeShare',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    _isLogin
                        ? 'Sign in to access your calendars and events'
                        : 'Create an account to start sharing your calendar',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Error message
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: theme.colorScheme.onErrorContainer),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Display name field (register only)
                  if (!_isLogin) ...[
                    TextFormField(
                      controller: _displayNameController,
                      decoration: const InputDecoration(
                        labelText: 'Display Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    autofillHints: [
                      _isLogin ? AutofillHints.email : AutofillHints.newUsername,
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    autofillHints: [
                      _isLogin ? AutofillHints.password : AutofillHints.newPassword,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (!_isLogin && value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),

                  // Forgot password link (login only)
                  if (_isLogin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _isLoading ? null : _showForgotPasswordDialog,
                        child: const Text('Forgot password?'),
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Submit button
                  FilledButton(
                    onPressed: _isLoading ? null : _submit,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isLogin ? 'Sign In' : 'Create Account'),
                  ),

                  const SizedBox(height: 16),

                  // Toggle login/register
                  TextButton(
                    onPressed: _isLoading ? null : _toggleMode,
                    child: Text(
                      _isLogin
                          ? "Don't have an account? Sign up"
                          : 'Already have an account? Sign in',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer
                  Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dialog for requesting a password reset email.
class _ForgotPasswordDialog extends StatefulWidget {
  final WidgetRef ref;
  final TextEditingController emailController;

  const _ForgotPasswordDialog({
    required this.ref,
    required this.emailController,
  });

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _submitted = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await widget.ref.read(requestPasswordResetProvider)(
        widget.emailController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _submitted = true;
        });
      }
    } catch (e) {
      // Always show success to prevent email enumeration
      if (mounted) {
        setState(() {
          _isLoading = false;
          _submitted = true;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return AlertDialog(
        title: const Text('Check Your Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.mark_email_read_outlined,
              size: 48,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              'If an account exists for ${widget.emailController.text.trim()}, '
              'you will receive a password reset link shortly.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: const Text('Reset Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your email address and we\'ll send you a link to reset your password.',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              autofocus: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send Reset Link'),
        ),
      ],
    );
  }
}

/// Dialog shown when authentication fails due to unverified email.
/// A verification email is automatically sent before showing this dialog.
class _EmailNotVerifiedDialog extends StatefulWidget {
  final WidgetRef ref;
  final String email;
  final bool fromSignup;

  const _EmailNotVerifiedDialog({
    required this.ref,
    required this.email,
    this.fromSignup = false,
  });

  @override
  State<_EmailNotVerifiedDialog> createState() =>
      _EmailNotVerifiedDialogState();
}

class _EmailNotVerifiedDialogState extends State<_EmailNotVerifiedDialog> {
  bool _isLoading = false;
  bool _resentAgain = false;

  Future<void> _resend() async {
    setState(() => _isLoading = true);

    try {
      await widget.ref.read(resendVerificationEmailProvider)(widget.email);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _resentAgain = true;
        });
      }
    } catch (e) {
      // Always show success to prevent enumeration
      if (mounted) {
        setState(() {
          _isLoading = false;
          _resentAgain = true;
        });
      }
    }
  }

  String get _title => widget.fromSignup
      ? 'Account Already Exists'
      : 'Email Not Verified';

  String get _message {
    if (widget.fromSignup) {
      return 'An account with ${widget.email} already exists but has not been verified yet. '
          "We've sent a new verification link to your inbox.";
    }
    return 'Your email address (${widget.email}) has not been verified yet. '
        "We've sent a verification link to your inbox.";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _resentAgain ? Icons.mark_email_read_outlined : Icons.email_outlined,
            size: 48,
            color: _resentAgain ? Colors.green : Colors.orange,
          ),
          const SizedBox(height: 16),
          Text(
            _resentAgain
                ? 'Another verification email has been sent to ${widget.email}.'
                : _message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Don't forget to check your spam folder.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        if (!_resentAgain)
          TextButton(
            onPressed: _isLoading ? null : _resend,
            child: _isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Resend Email'),
          ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
