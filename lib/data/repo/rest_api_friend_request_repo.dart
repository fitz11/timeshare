// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:convert';

import 'package:timeshare/data/models/friend_request/friend_request.dart';
import 'package:timeshare/data/repo/friend_request_repo.dart';
import 'package:timeshare/data/services/api_client.dart';

/// REST API implementation of [FriendRequestRepository].
///
/// Designed to work with a Django REST Framework backend.
/// Uses polling for stream-based watch methods since REST doesn't support
/// real-time updates natively.
class RestApiFriendRequestRepository implements FriendRequestRepository {
  final ApiClient _client;
  final Duration _pollInterval;

  RestApiFriendRequestRepository({
    required ApiClient client,
    Duration pollInterval = const Duration(seconds: 30),
  })  : _client = client,
        _pollInterval = pollInterval;

  @override
  Future<List<FriendRequest>> getIncomingRequests() async {
    final response = await _client.get('/api/v1/timeshare/friend-requests/incoming/');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => FriendRequest.fromJson(json)).toList();
  }

  @override
  Future<List<FriendRequest>> getSentRequests() async {
    final response = await _client.get('/api/v1/timeshare/friend-requests/sent/');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => FriendRequest.fromJson(json)).toList();
  }

  @override
  Future<FriendRequest> sendRequest(String targetUid) async {
    final response = await _client.post(
      '/api/v1/timeshare/friend-requests/',
      body: jsonEncode({'to_uid': targetUid}),
    );
    return FriendRequest.fromJson(jsonDecode(response.body));
  }

  @override
  Future<void> acceptRequest(String requestId) async {
    await _client.post('/api/v1/timeshare/friend-requests/$requestId/accept/');
  }

  @override
  Future<void> declineRequest(String requestId) async {
    await _client.post('/api/v1/timeshare/friend-requests/$requestId/decline/');
  }

  @override
  Future<void> cancelRequest(String requestId) async {
    await _client.delete('/api/v1/timeshare/friend-requests/$requestId/');
  }

  @override
  Stream<List<FriendRequest>> watchIncomingRequests() async* {
    // Initial fetch
    yield await getIncomingRequests();

    // Poll for updates
    await for (final _ in Stream.periodic(_pollInterval)) {
      try {
        yield await getIncomingRequests();
      } catch (e) {
        // On error, continue polling (don't break stream)
      }
    }
  }
}
