// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/foundation.dart';
import 'package:timeshare/data/services/api_client.dart';
import 'package:timeshare/data/services/rest_api_auth_service.dart';

/// Converts exceptions to user-friendly error messages.
/// Hides internal implementation details from users.
String formatError(Object error) {
  if (error is AuthException) {
    return error.message;
  }
  if (error is ApiException) {
    return _formatApiError(error);
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

String _formatApiError(ApiException error) {
  switch (error.statusCode) {
    case 400:
      return error.message.isNotEmpty
          ? error.message
          : 'Invalid request. Please check your input.';
    case 401:
      return 'Your session has expired. Please sign in again.';
    case 403:
      return 'You do not have permission to perform this action.';
    case 404:
      return 'The requested item was not found.';
    case 409:
      return error.message.isNotEmpty
          ? error.message
          : 'A conflict occurred. Please try again.';
    case 429:
      return 'Too many requests. Please try again later.';
    case >= 500:
      return 'Server error. Please try again later.';
    default:
      debugPrint('Unhandled API error code: ${error.statusCode}');
      return error.message.isNotEmpty
          ? error.message
          : 'An error occurred. Please try again.';
  }
}
