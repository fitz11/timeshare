// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeshare/data/models/friend_request/friend_request.dart';
import 'package:timeshare/data/repo/friend_request_repo.dart';
import 'package:timeshare/data/repo/rest_api_friend_request_repo.dart';
import 'package:timeshare/data/repo/logged_friend_request_repo.dart';
import 'package:timeshare/data/services/api_client.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/providers/config/config_providers.dart';
import 'package:timeshare/providers/user/user_providers.dart';

part 'friend_request_providers.g.dart';

/// Friend request repository provider - uses REST API
@riverpod
FriendRequestRepository friendRequestRepository(Ref ref) {
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
}

/// Stream of incoming friend requests (polling-based).
@riverpod
Stream<List<FriendRequest>> incomingFriendRequests(Ref ref) {
  ref.keepAlive();

  // Invalidate when auth state changes
  ref.listen(authStateProvider, (prev, next) {
    ref.invalidateSelf();
  });

  final repo = ref.watch(friendRequestRepositoryProvider);
  return repo.watchIncomingRequests();
}

/// Future of sent friend requests.
@riverpod
Future<List<FriendRequest>> sentFriendRequests(Ref ref) async {
  // Invalidate when auth state changes
  ref.listen(authStateProvider, (prev, next) {
    ref.invalidateSelf();
  });

  final repo = ref.watch(friendRequestRepositoryProvider);
  return repo.getSentRequests();
}

/// Count of pending incoming requests (for badge display).
@riverpod
int pendingRequestCount(Ref ref) {
  final requestsAsync = ref.watch(incomingFriendRequestsProvider);
  final requests = requestsAsync.value ?? [];
  return requests.where((r) => r.isPendingAndValid).length;
}

/// Friend request mutations notifier.
@riverpod
class FriendRequestNotifier extends _$FriendRequestNotifier {
  FriendRequestRepository get _repo => ref.read(friendRequestRepositoryProvider);

  @override
  void build() {
    // No initial state needed
  }

  /// Send a friend request to another user.
  ///
  /// Returns the created request on success.
  /// Throws ApiException if:
  /// - Target user has already sent a request (status 400)
  /// - Users are already friends (status 400)
  Future<FriendRequest> sendRequest({required String targetUid}) async {
    final request = await _repo.sendRequest(targetUid);
    ref.invalidate(sentFriendRequestsProvider);
    return request;
  }

  /// Accept a friend request.
  ///
  /// This adds both users to each other's friends lists.
  Future<void> acceptRequest({required String requestId}) async {
    await _repo.acceptRequest(requestId);
    // Refresh friends list and requests
    ref.invalidate(userFriendsProvider);
    ref.invalidate(incomingFriendRequestsProvider);
  }

  /// Decline a friend request.
  Future<void> declineRequest({required String requestId}) async {
    await _repo.declineRequest(requestId);
    ref.invalidate(incomingFriendRequestsProvider);
  }

  /// Cancel a sent friend request.
  Future<void> cancelRequest({required String requestId}) async {
    await _repo.cancelRequest(requestId);
    ref.invalidate(sentFriendRequestsProvider);
  }
}
