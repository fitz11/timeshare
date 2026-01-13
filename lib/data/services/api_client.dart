// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';
import 'dart:io';

/// Exception thrown when an API request fails.
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final String? body;

  ApiException({
    required this.statusCode,
    required this.message,
    this.body,
  });

  /// Returns true if this is an authentication error (invalid/revoked API key).
  bool get isAuthError => statusCode == 401;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Response from an API request.
class ApiResponse {
  final int statusCode;
  final String body;
  final Map<String, String> headers;

  ApiResponse({
    required this.statusCode,
    required this.body,
    required this.headers,
  });
}

/// Abstract HTTP client for REST API communication.
///
/// This abstraction allows for:
/// - Easy testing with mock implementations
/// - Centralized authentication header injection
/// - Consistent error handling
/// - Base URL configuration
abstract class ApiClient {
  Future<ApiResponse> get(String path);
  Future<ApiResponse> post(String path, {String? body});
  Future<ApiResponse> put(String path, {String? body});
  Future<ApiResponse> patch(String path, {String? body});
  Future<ApiResponse> delete(String path);
}

/// Callback type for retrieving the current API key.
typedef ApiKeyProvider = String? Function();

/// HTTP implementation of [ApiClient] using dart:io HttpClient.
///
/// Handles:
/// - API key authentication via Authorization header
/// - JSON content-type headers
/// - Base URL prefixing
/// - Error response parsing
class HttpApiClient implements ApiClient {
  final String baseUrl;
  final HttpClient _httpClient;
  final ApiKeyProvider _getApiKey;

  HttpApiClient({
    required this.baseUrl,
    required ApiKeyProvider getApiKey,
    HttpClient? httpClient,
  })  : _getApiKey = getApiKey,
        _httpClient = httpClient ?? HttpClient();

  Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Map<String, String> _buildHeaders() {
    final headers = Map<String, String>.from(_defaultHeaders);
    final apiKey = _getApiKey();
    if (apiKey != null) {
      headers['Authorization'] = 'Api-Key $apiKey';
    }
    return headers;
  }

  Future<ApiResponse> _request(
    String method,
    String path, {
    String? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = _buildHeaders();

    final request = await _httpClient.openUrl(method, uri);

    // Set headers
    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    // Write body if present
    if (body != null) {
      request.write(body);
    }

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    final responseHeaders = <String, String>{};
    response.headers.forEach((name, values) {
      responseHeaders[name] = values.join(', ');
    });

    // Check for errors
    if (response.statusCode >= 400) {
      throw ApiException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(responseBody, response.statusCode),
        body: responseBody,
      );
    }

    return ApiResponse(
      statusCode: response.statusCode,
      body: responseBody,
      headers: responseHeaders,
    );
  }

  String _extractErrorMessage(String body, int statusCode) {
    try {
      final json = jsonDecode(body);
      if (json is Map) {
        // Common DRF error formats
        if (json.containsKey('detail')) return json['detail'];
        if (json.containsKey('message')) return json['message'];
        if (json.containsKey('error')) return json['error'];
        // Validation errors
        if (json.containsKey('non_field_errors')) {
          return (json['non_field_errors'] as List).join(', ');
        }
      }
    } catch (_) {
      // Not JSON, use raw body
    }
    return 'HTTP $statusCode: ${body.isEmpty ? 'No response body' : body.substring(0, body.length.clamp(0, 100))}';
  }

  @override
  Future<ApiResponse> get(String path) => _request('GET', path);

  @override
  Future<ApiResponse> post(String path, {String? body}) =>
      _request('POST', path, body: body);

  @override
  Future<ApiResponse> put(String path, {String? body}) =>
      _request('PUT', path, body: body);

  @override
  Future<ApiResponse> patch(String path, {String? body}) =>
      _request('PATCH', path, body: body);

  @override
  Future<ApiResponse> delete(String path) => _request('DELETE', path);
}
