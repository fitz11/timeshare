// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:timeshare/data/models/friend_request/friend_request.dart';

/// Abstract interface for friend request operations.
///
/// This abstraction allows swapping between different backend implementations
/// (Firebase, REST API, etc.) without changing the consuming code.
abstract class FriendRequestRepository {
  /// Get all pending friend requests sent TO the current user.
  Future<List<FriendRequest>> getIncomingRequests();

  /// Get all pending friend requests sent BY the current user.
  Future<List<FriendRequest>> getSentRequests();

  /// Send a friend request to another user.
  ///
  /// Fails with an error if:
  /// - The target user has already sent a request to the current user
  /// - The users are already friends
  /// - A pending request already exists
  Future<FriendRequest> sendRequest(String targetUid);

  /// Accept a pending friend request.
  ///
  /// This adds both users to each other's friends lists.
  Future<void> acceptRequest(String requestId);

  /// Decline a pending friend request.
  ///
  /// The request status is updated to declined.
  Future<void> declineRequest(String requestId);

  /// Cancel a sent friend request.
  ///
  /// Only the sender can cancel a request.
  Future<void> cancelRequest(String requestId);

  /// Stream of incoming friend requests (polling-based for REST API).
  ///
  /// This stream will periodically poll for updates since REST APIs
  /// don't support real-time subscriptions.
  Stream<List<FriendRequest>> watchIncomingRequests();
}
