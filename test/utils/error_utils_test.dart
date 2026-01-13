// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/services/api_client.dart';
import 'package:timeshare/data/services/rest_api_auth_service.dart';
import 'package:timeshare/utils/error_utils.dart';

void main() {
  group('formatError - AuthException', () {
    test('formats auth exception with message', () {
      final error = AuthException(statusCode: 401, message: 'Invalid credentials');
      final message = formatError(error);
      expect(message, 'Invalid credentials');
    });

    test('formats auth exception with different message', () {
      final error = AuthException(statusCode: 403, message: 'Account has been disabled');
      final message = formatError(error);
      expect(message, 'Account has been disabled');
    });
  });

  group('formatError - ApiException', () {
    test('formats 400 error with message', () {
      final error = ApiException(statusCode: 400, message: 'Invalid email format');
      final message = formatError(error);
      expect(message, 'Invalid email format');
    });

    test('formats 400 error without message', () {
      final error = ApiException(statusCode: 400, message: '');
      final message = formatError(error);
      expect(message, 'Invalid request. Please check your input.');
    });

    test('formats 401 error', () {
      final error = ApiException(statusCode: 401, message: 'Unauthorized');
      final message = formatError(error);
      expect(message, 'Your session has expired. Please sign in again.');
    });

    test('formats 403 error', () {
      final error = ApiException(statusCode: 403, message: 'Forbidden');
      final message = formatError(error);
      expect(message, 'You do not have permission to perform this action.');
    });

    test('formats 404 error', () {
      final error = ApiException(statusCode: 404, message: 'Not found');
      final message = formatError(error);
      expect(message, 'The requested item was not found.');
    });

    test('formats 409 error with message', () {
      final error = ApiException(statusCode: 409, message: 'Email already exists');
      final message = formatError(error);
      expect(message, 'Email already exists');
    });

    test('formats 409 error without message', () {
      final error = ApiException(statusCode: 409, message: '');
      final message = formatError(error);
      expect(message, 'A conflict occurred. Please try again.');
    });

    test('formats 429 error', () {
      final error = ApiException(statusCode: 429, message: 'Rate limited');
      final message = formatError(error);
      expect(message, 'Too many requests. Please try again later.');
    });

    test('formats 500 error', () {
      final error = ApiException(statusCode: 500, message: 'Internal server error');
      final message = formatError(error);
      expect(message, 'Server error. Please try again later.');
    });

    test('formats 502 error', () {
      final error = ApiException(statusCode: 502, message: 'Bad gateway');
      final message = formatError(error);
      expect(message, 'Server error. Please try again later.');
    });

    test('formats 503 error', () {
      final error = ApiException(statusCode: 503, message: 'Service unavailable');
      final message = formatError(error);
      expect(message, 'Server error. Please try again later.');
    });

    test('formats unknown status code with message', () {
      final error = ApiException(statusCode: 418, message: "I'm a teapot");
      final message = formatError(error);
      expect(message, "I'm a teapot");
    });

    test('formats unknown status code without message', () {
      final error = ApiException(statusCode: 418, message: '');
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
