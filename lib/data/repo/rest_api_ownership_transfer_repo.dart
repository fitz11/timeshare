// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:convert';

import 'package:timeshare/data/models/ownership_transfer/ownership_transfer_request.dart';
import 'package:timeshare/data/repo/ownership_transfer_repo.dart';
import 'package:timeshare/data/services/api_client.dart';

/// REST API implementation of [OwnershipTransferRepository].
///
/// Designed to work with a Django REST Framework backend.
/// Uses polling for stream-based watch methods since REST doesn't support
/// real-time updates natively.
class RestApiOwnershipTransferRepository implements OwnershipTransferRepository {
  final ApiClient _client;
  final Duration _pollInterval;

  RestApiOwnershipTransferRepository({
    required ApiClient client,
    Duration pollInterval = const Duration(seconds: 30),
  })  : _client = client,
        _pollInterval = pollInterval;

  @override
  Future<List<OwnershipTransferRequest>> getIncomingTransfers() async {
    final response = await _client.get('/api/v1/timeshare/ownership-transfers/incoming/');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => OwnershipTransferRequest.fromJson(json)).toList();
  }

  @override
  Future<List<OwnershipTransferRequest>> getSentTransfers() async {
    final response = await _client.get('/api/v1/timeshare/ownership-transfers/sent/');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => OwnershipTransferRequest.fromJson(json)).toList();
  }

  @override
  Future<OwnershipTransferRequest> requestTransfer(
    String calendarId,
    String toUid,
  ) async {
    final response = await _client.post(
      '/api/v1/timeshare/ownership-transfers/',
      body: jsonEncode({
        'calendar_id': calendarId,
        'to_uid': toUid,
      }),
    );
    return OwnershipTransferRequest.fromJson(jsonDecode(response.body));
  }

  @override
  Future<void> acceptTransfer(String requestId) async {
    await _client.post('/api/v1/timeshare/ownership-transfers/$requestId/accept/');
  }

  @override
  Future<void> declineTransfer(String requestId) async {
    await _client.post('/api/v1/timeshare/ownership-transfers/$requestId/decline/');
  }

  @override
  Future<void> cancelTransfer(String requestId) async {
    await _client.delete('/api/v1/timeshare/ownership-transfers/$requestId/');
  }

  @override
  Stream<List<OwnershipTransferRequest>> watchIncomingTransfers() async* {
    // Initial fetch
    yield await getIncomingTransfers();

    // Poll for updates
    await for (final _ in Stream.periodic(_pollInterval)) {
      try {
        yield await getIncomingTransfers();
      } catch (e) {
        // On error, continue polling (don't break stream)
      }
    }
  }
}
