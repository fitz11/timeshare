// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/exceptions/conflict_exception.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/repo/rest_api_repo.dart';
import 'package:timeshare/data/services/api_client.dart';

/// Mock ApiClient for testing RestApiRepository error handling.
class MockApiClient implements ApiClient {
  final List<_MockResponse> _responses = [];
  int _callIndex = 0;

  void addResponse(int statusCode, String body) {
    _responses.add(_MockResponse(statusCode: statusCode, body: body));
  }

  void addException(Exception exception) {
    _responses.add(_MockResponse(exception: exception));
  }

  void reset() {
    _responses.clear();
    _callIndex = 0;
  }

  Future<ApiResponse> _handleRequest() async {
    if (_callIndex >= _responses.length) {
      // Default to 200 OK with empty list
      return ApiResponse(statusCode: 200, body: '[]', headers: {});
    }

    final response = _responses[_callIndex++];

    if (response.exception != null) {
      throw response.exception!;
    }

    if (response.statusCode >= 400) {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'HTTP ${response.statusCode}',
        body: response.body,
      );
    }

    return ApiResponse(
      statusCode: response.statusCode,
      body: response.body ?? '',
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

class _MockResponse {
  final int statusCode;
  final String? body;
  final Exception? exception;

  _MockResponse({this.statusCode = 200, this.body, this.exception});
}

void main() {
  group('RestApiRepository error handling', () {
    late MockApiClient mockClient;
    late RestApiRepository repository;

    setUp(() {
      mockClient = MockApiClient();
      repository = RestApiRepository(
        client: mockClient,
        pollInterval: const Duration(milliseconds: 100),
      );
    });

    group('getCalendarById', () {
      test('returns null for 404 response', () async {
        mockClient.addResponse(404, '{"detail": "Not found"}');

        final result = await repository.getCalendarById('nonexistent-id');

        expect(result, isNull);
      });

      test('throws ApiException for other errors', () async {
        mockClient.addResponse(500, '{"detail": "Server error"}');

        expect(
          () => repository.getCalendarById('some-id'),
          throwsA(isA<ApiException>()),
        );
      });

      test('returns calendar for successful response', () async {
        final calendarJson = jsonEncode({
          'id': 'cal-123',
          'name': 'Test Calendar',
          'owner': 'user-123',
          'sharedWith': <String>[],
          'version': 1,
        });
        mockClient.addResponse(200, calendarJson);

        final result = await repository.getCalendarById('cal-123');

        expect(result, isNotNull);
        expect(result!.id, 'cal-123');
        expect(result.name, 'Test Calendar');
      });
    });

    group('updateCalendar conflict handling', () {
      test('throws ConflictException on 409 response', () async {
        final serverCalendar = {
          'id': 'cal-123',
          'name': 'Server Version',
          'owner': 'user-123',
          'sharedWith': <String>[],
          'version': 2,
        };
        mockClient.addResponse(409, jsonEncode({'data': serverCalendar}));

        final localCalendar = Calendar(
          id: 'cal-123',
          name: 'Local Version',
          owner: 'user-123',
          version: 1,
        );

        expect(
          () => repository.updateCalendar(localCalendar),
          throwsA(
            isA<ConflictException>()
                .having((e) => e.localVersion, 'localVersion', 1)
                .having((e) => e.serverVersion, 'serverVersion', 2),
          ),
        );
      });

      test('includes server data in ConflictException', () async {
        final serverCalendar = {
          'id': 'cal-123',
          'name': 'Server Version',
          'owner': 'user-123',
          'sharedWith': <String>[],
          'version': 5,
        };
        mockClient.addResponse(409, jsonEncode({'data': serverCalendar}));

        final localCalendar = Calendar(
          id: 'cal-123',
          name: 'Local Version',
          owner: 'user-123',
          version: 3,
        );

        try {
          await repository.updateCalendar(localCalendar);
          fail('Expected ConflictException');
        } on ConflictException catch (e) {
          expect(e.serverData, isA<Calendar>());
          final serverData = e.serverData as Calendar;
          expect(serverData.name, 'Server Version');
          expect(serverData.version, 5);
        }
      });

      test('rethrows other errors', () async {
        mockClient.addResponse(500, '{"detail": "Server error"}');

        final calendar = Calendar(
          id: 'cal-123',
          name: 'Test',
          owner: 'user-123',
        );

        expect(
          () => repository.updateCalendar(calendar),
          throwsA(isA<ApiException>()),
        );
      });
    });

    group('watchAllAvailableCalendars polling', () {
      test('yields initial value immediately', () async {
        final calendarsJson = jsonEncode([
          {
            'id': 'cal-1',
            'name': 'Calendar 1',
            'owner': 'user-123',
            'sharedWith': <String>[],
            'version': 1,
          }
        ]);
        mockClient.addResponse(200, calendarsJson);

        final stream = repository.watchAllAvailableCalendars();
        final firstValue = await stream.first;

        expect(firstValue.length, 1);
        expect(firstValue.first.name, 'Calendar 1');
      });

      test('continues polling after error', () async {
        // First call succeeds
        mockClient.addResponse(
          200,
          jsonEncode([
            {'id': 'cal-1', 'name': 'Calendar 1', 'owner': 'user-123', 'sharedWith': [], 'version': 1}
          ]),
        );
        // Second call fails
        mockClient.addException(Exception('Network error'));
        // Third call succeeds
        mockClient.addResponse(
          200,
          jsonEncode([
            {'id': 'cal-1', 'name': 'Calendar 1', 'owner': 'user-123', 'sharedWith': [], 'version': 1},
            {'id': 'cal-2', 'name': 'Calendar 2', 'owner': 'user-123', 'sharedWith': [], 'version': 1}
          ]),
        );

        final stream = repository.watchAllAvailableCalendars();
        final results = <List<Calendar>>[];

        // Collect first 2 successful emissions
        await for (final value in stream) {
          results.add(value);
          if (results.length >= 2) break;
        }

        expect(results.length, 2);
        expect(results[0].length, 1);
        expect(results[1].length, 2); // Second result after error recovery
      });
    });

    group('updateEvent conflict handling', () {
      test('throws ConflictException on 409 with server event data', () async {
        final serverEvent = {
          'id': 'evt-123',
          'name': 'Server Event',
          'time': '2025-01-15T10:00:00.000Z',
          'color': 4294901760,
          'shape': 'circle',
          'version': 3,
        };
        mockClient.addResponse(409, jsonEncode({'data': serverEvent}));

        final localEvent = Event(
          id: 'evt-123',
          name: 'Local Event',
          time: DateTime(2025, 1, 15, 10),
          version: 1,
        );

        expect(
          () => repository.updateEvent('cal-123', localEvent),
          throwsA(
            isA<ConflictException>()
                .having((e) => e.localVersion, 'localVersion', 1)
                .having((e) => e.serverVersion, 'serverVersion', 3),
          ),
        );
      });
    });
  });
}
