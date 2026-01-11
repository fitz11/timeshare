import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/utils/error_utils.dart';

void main() {
  group('formatError - FirebaseAuthException', () {
    test('formats user-not-found error', () {
      final error = FirebaseAuthException(code: 'user-not-found');
      final message = formatError(error);
      expect(message, 'No account found with this email.');
    });

    test('formats wrong-password error', () {
      final error = FirebaseAuthException(code: 'wrong-password');
      final message = formatError(error);
      expect(message, 'Incorrect password.');
    });

    test('formats email-already-in-use error', () {
      final error = FirebaseAuthException(code: 'email-already-in-use');
      final message = formatError(error);
      expect(message, 'An account already exists with this email.');
    });

    test('formats weak-password error', () {
      final error = FirebaseAuthException(code: 'weak-password');
      final message = formatError(error);
      expect(message, 'Please choose a stronger password.');
    });

    test('formats invalid-email error', () {
      final error = FirebaseAuthException(code: 'invalid-email');
      final message = formatError(error);
      expect(message, 'Please enter a valid email address.');
    });

    test('formats user-disabled error', () {
      final error = FirebaseAuthException(code: 'user-disabled');
      final message = formatError(error);
      expect(message, 'This account has been disabled.');
    });

    test('formats too-many-requests error', () {
      final error = FirebaseAuthException(code: 'too-many-requests');
      final message = formatError(error);
      expect(message, 'Too many attempts. Please try again later.');
    });

    test('formats network-request-failed error', () {
      final error = FirebaseAuthException(code: 'network-request-failed');
      final message = formatError(error);
      expect(message, 'Network error. Please check your connection.');
    });

    test('formats unknown auth error with generic message', () {
      final error = FirebaseAuthException(code: 'unknown-error-code');
      final message = formatError(error);
      expect(message, 'Authentication error. Please try again.');
    });
  });

  group('formatError - FirebaseException', () {
    test('formats permission-denied error', () {
      final error = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
      );
      final message = formatError(error);
      expect(message, 'You do not have permission to perform this action.');
    });

    test('formats not-found error', () {
      final error = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'not-found',
      );
      final message = formatError(error);
      expect(message, 'The requested item was not found.');
    });

    test('formats unavailable error', () {
      final error = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'unavailable',
      );
      final message = formatError(error);
      expect(message, 'Service temporarily unavailable. Please try again.');
    });

    test('formats cancelled error', () {
      final error = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'cancelled',
      );
      final message = formatError(error);
      expect(message, 'The operation was cancelled.');
    });

    test('formats deadline-exceeded error', () {
      final error = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'deadline-exceeded',
      );
      final message = formatError(error);
      expect(message, 'The operation timed out. Please try again.');
    });

    test('formats resource-exhausted error', () {
      final error = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'resource-exhausted',
      );
      final message = formatError(error);
      expect(message, 'Too many requests. Please try again later.');
    });

    test('formats unknown firebase error with generic message', () {
      final error = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'unknown-code',
      );
      final message = formatError(error);
      expect(message, 'An error occurred. Please try again.');
    });
  });

  group('formatError - Exception', () {
    test('extracts message from Exception', () {
      final error = Exception('Custom error message');
      final message = formatError(error);
      expect(message, 'Custom error message');
    });

    test('handles Exception without prefix', () {
      final error = FormatException('Bad format');
      final message = formatError(error);
      expect(message.contains('Bad format'), true);
    });
  });

  group('formatError - Unknown errors', () {
    test('returns generic message for unknown error type', () {
      final message = formatError('A plain string error');
      expect(message, 'An unexpected error occurred. Please try again.');
    });

    test('returns generic message for int', () {
      final message = formatError(404);
      expect(message, 'An unexpected error occurred. Please try again.');
    });

    test('returns generic message for map', () {
      final message = formatError({'error': 'test'});
      expect(message, 'An unexpected error occurred. Please try again.');
    });
  });
}
