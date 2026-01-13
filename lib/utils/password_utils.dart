// SPDX-License-Identifier: AGPL-3.0-or-later

// Password validation utilities following backend password rules.
//
// Rules:
// - Minimum 8 characters
// - Cannot be purely numeric
// - Cannot be a common password
// - Cannot be too similar to user attributes

/// Common passwords that are rejected by the backend.
const _commonPasswords = {
  'password',
  'password1',
  'password123',
  '12345678',
  '123456789',
  '1234567890',
  'qwerty123',
  'letmein',
  'welcome',
  'admin123',
  'iloveyou',
  'sunshine',
  'princess',
  'football',
  'baseball',
  'dragon',
  'master',
  'monkey',
  'shadow',
  'michael',
  'jennifer',
  'trustno1',
  'batman',
  'thomas',
};

/// Validates a password and returns an error message if invalid, null if valid.
///
/// [email] and [displayName] are optional but used to check similarity.
String? validatePassword(
  String password, {
  String? email,
  String? displayName,
}) {
  // Check minimum length
  if (password.length < 8) {
    return 'Password must be at least 8 characters';
  }

  // Check if purely numeric
  if (RegExp(r'^[0-9]+$').hasMatch(password)) {
    return 'Password cannot be entirely numeric';
  }

  // Check against common passwords
  if (_commonPasswords.contains(password.toLowerCase())) {
    return 'This password is too common. Please choose a stronger password.';
  }

  // Check similarity to email (if provided)
  if (email != null && email.isNotEmpty) {
    final emailPrefix = email.split('@').first.toLowerCase();
    if (emailPrefix.length >= 4 &&
        password.toLowerCase().contains(emailPrefix)) {
      return 'Password cannot be too similar to your email';
    }
  }

  // Check similarity to display name (if provided)
  if (displayName != null && displayName.isNotEmpty) {
    final nameLower = displayName.toLowerCase().replaceAll(' ', '');
    if (nameLower.length >= 4 && password.toLowerCase().contains(nameLower)) {
      return 'Password cannot be too similar to your name';
    }
  }

  return null; // Valid
}

/// Validates that passwords match for confirmation.
String? validatePasswordConfirmation(String password, String confirmation) {
  if (confirmation.isEmpty) {
    return 'Please confirm your password';
  }
  if (password != confirmation) {
    return 'Passwords do not match';
  }
  return null;
}

/// Returns password strength as a value from 0.0 to 1.0.
double getPasswordStrength(String password) {
  if (password.isEmpty) return 0.0;

  double strength = 0.0;

  // Length contribution (up to 0.3)
  if (password.length >= 8) strength += 0.1;
  if (password.length >= 12) strength += 0.1;
  if (password.length >= 16) strength += 0.1;

  // Character variety (up to 0.4)
  if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.1;
  if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.1;
  if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.1;
  if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.1;

  // Bonus for mixing multiple character types (up to 0.3)
  int types = 0;
  if (RegExp(r'[a-z]').hasMatch(password)) types++;
  if (RegExp(r'[A-Z]').hasMatch(password)) types++;
  if (RegExp(r'[0-9]').hasMatch(password)) types++;
  if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) types++;

  if (types >= 3) strength += 0.2;
  if (types >= 4) strength += 0.1;

  return strength.clamp(0.0, 1.0);
}

/// Returns a descriptive label for password strength.
String getPasswordStrengthLabel(double strength) {
  if (strength < 0.3) return 'Weak';
  if (strength < 0.5) return 'Fair';
  if (strength < 0.7) return 'Good';
  return 'Strong';
}
