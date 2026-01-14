// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/friend_request/friend_request.dart';
import 'package:timeshare/data/repo/friend_request_repo.dart';
import 'package:timeshare/data/repo/rest_api_friend_request_repo.dart';
import 'package:timeshare/data/repo/logged_friend_request_repo.dart';
import 'package:timeshare/data/services/api_client.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/providers/config/config_providers.dart';
import 'package:timeshare/providers/user/user_providers.dart';

/// Friend request repository provider - uses REST API.
final friendRequestRepositoryProvider = Provider<FriendRequestRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  final authService = ref.watch(authServiceProvider);
  final logger = ref.watch(appLoggerProvider);

  final apiClient = HttpApiClient(
    baseUrl: config.apiBaseUrl,
    getApiKey: () => authService.apiKey,
  );

  return LoggedFriendRequestRepository(
    RestApiFriendRequestRepository(client: apiClient),
    logger,
  );
});

/// Stream of incoming friend requests (polling-based).
final incomingFriendRequestsProvider =
    StreamProvider<List<FriendRequest>>((ref) {
  ref.keepAlive();

  ref.listen(authStateProvider, (prev, next) {
    ref.invalidateSelf();
  });

  final repo = ref.watch(friendRequestRepositoryProvider);
  return repo.watchIncomingRequests();
});

/// Future of sent friend requests.
final sentFriendRequestsProvider =
    FutureProvider<List<FriendRequest>>((ref) async {
  ref.listen(authStateProvider, (prev, next) {
    ref.invalidateSelf();
  });

  final repo = ref.watch(friendRequestRepositoryProvider);
  return repo.getSentRequests();
});

/// Count of pending incoming requests (for badge display).
final pendingRequestCountProvider = Provider<int>((ref) {
  final requestsAsync = ref.watch(incomingFriendRequestsProvider);
  final requests = requestsAsync.value ?? [];
  return requests.where((r) => r.isPendingAndValid).length;
});

/// Friend request mutations notifier.
class FriendRequestNotifier extends Notifier<void> {
  FriendRequestRepository get _repo => ref.read(friendRequestRepositoryProvider);

  @override
  void build() {
    // No initial state needed
  }

  Future<FriendRequest> sendRequest({required String targetUid}) async {
    final request = await _repo.sendRequest(targetUid);
    ref.invalidate(sentFriendRequestsProvider);
    return request;
  }

  Future<void> acceptRequest({required String requestId}) async {
    await _repo.acceptRequest(requestId);
    ref.invalidate(userFriendsProvider);
    ref.invalidate(incomingFriendRequestsProvider);
  }

  Future<void> declineRequest({required String requestId}) async {
    await _repo.declineRequest(requestId);
    ref.invalidate(incomingFriendRequestsProvider);
  }

  Future<void> cancelRequest({required String requestId}) async {
    await _repo.cancelRequest(requestId);
    ref.invalidate(sentFriendRequestsProvider);
  }
}

final friendRequestProvider =
    NotifierProvider<FriendRequestNotifier, void>(
  FriendRequestNotifier.new,
);
