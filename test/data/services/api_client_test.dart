// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/services/api_client.dart';

/// Mock ApiClient that can be configured to return specific responses.
class MockApiClient implements ApiClient {
  int? nextStatusCode;
  String? nextBody;
  Exception? nextException;

  void setNextResponse(int statusCode, String body) {
    nextStatusCode = statusCode;
    nextBody = body;
    nextException = null;
  }

  void setNextException(Exception exception) {
    nextException = exception;
    nextStatusCode = null;
    nextBody = null;
  }

  Future<ApiResponse> _handleRequest() async {
    if (nextException != null) {
      throw nextException!;
    }
    if (nextStatusCode != null && nextStatusCode! >= 400) {
      throw ApiException(
        statusCode: nextStatusCode!,
        message: 'HTTP $nextStatusCode',
        body: nextBody,
      );
    }
    return ApiResponse(
      statusCode: nextStatusCode ?? 200,
      body: nextBody ?? '',
      headers: {},
    );
  }

  @override
  Future<ApiResponse> get(String path) => _handleRequest();

  @override
  Future<ApiResponse> post(String path, {String? body}) => _handleRequest();

  @override
  Future<ApiResponse> put(String path, {String? body}) => _handleRequest();

  @override
  Future<ApiResponse> patch(String path, {String? body}) => _handleRequest();

  @override
  Future<ApiResponse> delete(String path) => _handleRequest();
}

void main() {
  group('ApiException', () {
    test('isAuthError returns true for 401 status', () {
      final exception = ApiException(statusCode: 401, message: 'Unauthorized');
      expect(exception.isAuthError, isTrue);
    });

    test('isAuthError returns false for non-401 status', () {
      expect(
        ApiException(statusCode: 400, message: 'Bad Request').isAuthError,
        isFalse,
      );
      expect(
        ApiException(statusCode: 403, message: 'Forbidden').isAuthError,
        isFalse,
      );
      expect(
        ApiException(statusCode: 500, message: 'Server Error').isAuthError,
        isFalse,
      );
    });

    test('toString includes status code and message', () {
      final exception = ApiException(statusCode: 404, message: 'Not Found');
      expect(exception.toString(), contains('404'));
      expect(exception.toString(), contains('Not Found'));
    });

    test('body is optional', () {
      final withBody = ApiException(
        statusCode: 400,
        message: 'Error',
        body: '{"detail": "Invalid"}',
      );
      final withoutBody = ApiException(statusCode: 400, message: 'Error');

      expect(withBody.body, isNotNull);
      expect(withoutBody.body, isNull);
    });
  });

  group('MockApiClient error handling', () {
    late MockApiClient client;

    setUp(() {
      client = MockApiClient();
    });

    test('throws ApiException on 4xx responses', () async {
      client.setNextResponse(400, '{"detail": "Bad Request"}');
      expect(
        () => client.get('/test'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 400)),
      );

      client.setNextResponse(404, '{"detail": "Not Found"}');
      expect(
        () => client.get('/test'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404)),
      );

      client.setNextResponse(401, '{"detail": "Unauthorized"}');
      expect(
        () => client.get('/test'),
        throwsA(isA<ApiException>().having((e) => e.isAuthError, 'isAuthError', isTrue)),
      );
    });

    test('throws ApiException on 5xx responses', () async {
      client.setNextResponse(500, '{"detail": "Internal Server Error"}');
      expect(
        () => client.get('/test'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500)),
      );

      client.setNextResponse(503, '{"detail": "Service Unavailable"}');
      expect(
        () => client.get('/test'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 503)),
      );
    });

    test('includes body in ApiException', () async {
      final errorBody = jsonEncode({'detail': 'Validation failed', 'errors': ['field1']});
      client.setNextResponse(422, errorBody);

      expect(
        () => client.post('/test', body: '{}'),
        throwsA(isA<ApiException>().having((e) => e.body, 'body', errorBody)),
      );
    });

    test('returns successful response for 2xx status', () async {
      client.setNextResponse(200, '{"data": "test"}');
      final response = await client.get('/test');
      expect(response.statusCode, 200);
      expect(response.body, '{"data": "test"}');
    });

    test('propagates exceptions', () async {
      client.setNextException(Exception('Network error'));
      expect(() => client.get('/test'), throwsA(isA<Exception>()));
    });
  });

  group('ApiResponse', () {
    test('stores status code, body, and headers', () {
      final response = ApiResponse(
        statusCode: 200,
        body: '{"key": "value"}',
        headers: {'content-type': 'application/json'},
      );

      expect(response.statusCode, 200);
      expect(response.body, '{"key": "value"}');
      expect(response.headers['content-type'], 'application/json');
    });
  });
}
