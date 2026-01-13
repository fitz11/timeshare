// SPDX-License-Identifier: AGPL-3.0-or-later

/// Exception thrown when a user attempts to login but their email is not verified.
class EmailNotVerifiedException implements Exception {
  /// The email address that needs verification.
  final String email;

  /// A user-friendly message.
  final String message;

  EmailNotVerifiedException({
    required this.email,
    this.message =
        'Email not verified. Please check your email for the verification link.',
  });

  @override
  String toString() => 'EmailNotVerifiedException: $message (email: $email)';
}
