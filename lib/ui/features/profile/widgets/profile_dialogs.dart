// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/user/app_user.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/user/user_providers.dart';
import 'package:timeshare/utils/error_utils.dart';
import 'package:timeshare/utils/password_utils.dart';

/// Shows a dialog to edit the user's display name.
void showEditDisplayNameDialog(
  BuildContext context,
  WidgetRef ref,
  AppUser user,
) {
  final controller = TextEditingController(text: user.displayName);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Display Name'),
      content: TextField(
        controller: controller,
        maxLength: 50,
        decoration: const InputDecoration(
          labelText: 'Display Name',
          hintText: 'Enter your display name',
        ),
        autofocus: true,
        textCapitalization: TextCapitalization.words,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            final newName = controller.text.trim();
            if (newName.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Display name cannot be empty'),
                  duration: Duration(seconds: 5),
                ),
              );
              return;
            }

            if (newName.length > 50) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Display name must be 50 characters or less'),
                  duration: Duration(seconds: 5),
                ),
              );
              return;
            }

            // Only allow letters, numbers, spaces, hyphens, and apostrophes
            final validNamePattern = RegExp(r"^[a-zA-Z0-9\s\-']+$");
            if (!validNamePattern.hasMatch(newName)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Display name can only contain letters, numbers, spaces, hyphens, and apostrophes',
                  ),
                  duration: Duration(seconds: 5),
                ),
              );
              return;
            }

            if (newName == user.displayName) {
              Navigator.pop(context);
              return;
            }

            try {
              await ref
                  .read(currentUserProvider.notifier)
                  .updateDisplayName(newName);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Display name updated'),
                    duration: Duration(seconds: 5),
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update: ${formatError(e)}'),
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

/// Shows a confirmation dialog for signing out.
void showLogoutDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.pop(context);
            try {
              await ref.read(signOutProvider)();
              // Navigation will be handled by AuthGate automatically
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to sign out: ${formatError(e)}'),
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Sign Out'),
        ),
      ],
    ),
  );
}

/// Shows the privacy policy dialog.
void showPrivacyPolicyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Privacy Policy'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Data We Collect',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '- Email address and display name\n'
              '- Calendar names and sharing settings\n'
              '- Event names, dates, and times\n'
              '- Friends list',
            ),
            SizedBox(height: 16),
            Text(
              'How We Use Your Data',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '- To provide calendar sharing functionality\n'
              '- To enable sharing with friends\n'
              '- To improve app stability via crash reports',
            ),
            SizedBox(height: 16),
            Text(
              'Data Storage',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your data is stored securely on our servers. '
              'Data is encrypted in transit and at rest, but is not '
              'end-to-end encrypted.',
            ),
            SizedBox(height: 16),
            Text(
              'Your Rights',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'You can delete your account and all associated data '
              'at any time through the app.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

/// Shows the security information dialog.
void showSecurityInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Security Information'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Important Notice',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your calendar data is NOT end-to-end encrypted. '
              'This means data can be accessed by database administrators.',
            ),
            SizedBox(height: 16),
            Text(
              'Recommendation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Do not store highly sensitive information such as:\n'
              '- Medical appointment details\n'
              '- Financial information\n'
              '- Confidential business data',
            ),
            SizedBox(height: 16),
            Text(
              'What IS Protected',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '- Your password (securely hashed)\n'
              '- Data in transit (HTTPS encryption)\n'
              '- Access control (only you and shared users can see your calendars)',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

/// Shows a dialog to change the user's password.
void showChangePasswordDialog(
  BuildContext context,
  WidgetRef ref,
  AppUser user,
) {
  showDialog(
    context: context,
    builder: (context) => _ChangePasswordDialog(ref: ref, user: user),
  );
}

class _ChangePasswordDialog extends StatefulWidget {
  final WidgetRef ref;
  final AppUser user;

  const _ChangePasswordDialog({required this.ref, required this.user});

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await widget.ref.read(changePasswordProvider)(
        _currentPasswordController.text,
        _newPasswordController.text,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change password: ${formatError(e)}'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureCurrent
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                ),
                obscureText: _obscureCurrent,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureNew ? Icons.visibility : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),
                  helperText: 'At least 8 characters, not purely numeric',
                  helperMaxLines: 2,
                ),
                obscureText: _obscureNew,
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  return validatePassword(
                    value,
                    email: widget.user.email,
                    displayName: widget.user.displayName,
                  );
                },
              ),
              if (_newPasswordController.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                _PasswordStrengthIndicator(
                  strength: getPasswordStrength(_newPasswordController.text),
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                obscureText: _obscureConfirm,
                validator: (value) => validatePasswordConfirmation(
                  _newPasswordController.text,
                  value ?? '',
                ),
              ),
            ],
          ),
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
              : const Text('Change Password'),
        ),
      ],
    );
  }
}

class _PasswordStrengthIndicator extends StatelessWidget {
  final double strength;

  const _PasswordStrengthIndicator({required this.strength});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = getPasswordStrengthLabel(strength);

    Color color;
    if (strength < 0.3) {
      color = colorScheme.error;
    } else if (strength < 0.5) {
      color = Colors.orange;
    } else if (strength < 0.7) {
      color = Colors.amber;
    } else {
      color = Colors.green;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: strength,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Shows a dialog to change the user's email address.
void showChangeEmailDialog(
  BuildContext context,
  WidgetRef ref,
  AppUser user,
) {
  showDialog(
    context: context,
    builder: (context) => _ChangeEmailDialog(ref: ref, user: user),
  );
}

class _ChangeEmailDialog extends StatefulWidget {
  final WidgetRef ref;
  final AppUser user;

  const _ChangeEmailDialog({required this.ref, required this.user});

  @override
  State<_ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<_ChangeEmailDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user.email;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final newEmail = _emailController.text.trim();
    if (newEmail == widget.user.email) {
      Navigator.pop(context);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await widget.ref.read(changeEmailProvider)(
        newEmail,
        _passwordController.text,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email changed successfully'),
            duration: Duration(seconds: 5),
          ),
        );
        // Refresh user data
        widget.ref.invalidate(currentUserProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change email: ${formatError(e)}'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Email'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'New Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  helperText: 'Required to confirm this change',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
            ],
          ),
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
              : const Text('Change Email'),
        ),
      ],
    );
  }
}
