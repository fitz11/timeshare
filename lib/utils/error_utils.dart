// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Converts exceptions to user-friendly error messages.
/// Hides internal implementation details from users.
String formatError(Object error) {
  if (error is FirebaseAuthException) {
    return _formatAuthError(error);
  }
  if (error is FirebaseException) {
    return _formatFirebaseError(error);
  }
  if (error is Exception) {
    // Extract message from Exception('message')
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring(11);
    }
    // Log the actual error for debugging
    debugPrint('Unhandled exception: $error');
    return message;
  }
  // Log unknown errors for debugging
  debugPrint('Unknown error type: $error');
  return 'An unexpected error occurred. Please try again.';
}

String _formatAuthError(FirebaseAuthException error) {
  switch (error.code) {
    case 'user-not-found':
      return 'No account found with this email.';
    case 'wrong-password':
      return 'Incorrect password.';
    case 'email-already-in-use':
      return 'An account already exists with this email.';
    case 'weak-password':
      return 'Please choose a stronger password.';
    case 'invalid-email':
      return 'Please enter a valid email address.';
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'too-many-requests':
      return 'Too many attempts. Please try again later.';
    case 'network-request-failed':
      return 'Network error. Please check your connection.';
    default:
      debugPrint('Unhandled auth error code: ${error.code}');
      return 'Authentication error. Please try again.';
  }
}

String _formatFirebaseError(FirebaseException error) {
  switch (error.code) {
    case 'permission-denied':
      return 'You do not have permission to perform this action.';
    case 'not-found':
      return 'The requested item was not found.';
    case 'unavailable':
      return 'Service temporarily unavailable. Please try again.';
    case 'cancelled':
      return 'The operation was cancelled.';
    case 'deadline-exceeded':
      return 'The operation timed out. Please try again.';
    case 'resource-exhausted':
      return 'Too many requests. Please try again later.';
    default:
      debugPrint('Unhandled Firebase error code: ${error.code}');
      return 'An error occurred. Please try again.';
  }
}
