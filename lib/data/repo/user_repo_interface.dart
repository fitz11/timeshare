// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:timeshare/data/models/user/app_user.dart';

/// Abstract interface for user data operations.
///
/// This abstraction allows swapping between different backend implementations
/// (Firebase, REST API, etc.) without changing the consuming code.
abstract class UserRepositoryInterface {
  /// The currently authenticated user's ID, or null if not authenticated.
  String? get currentUserId;

  /// The currently authenticated user's profile, fetched asynchronously.
  Future<AppUser?> get currentUser;

  /// Called after successful authentication to ensure user profile exists.
  /// Creates a new user document if this is first login, otherwise no-op.
  Future<void> signInOrRegister();

  /// Retrieve a user by their UID.
  /// If [uid] is empty, defaults to the current user.
  Future<AppUser?> getUserById([String uid = '']);

  /// Search for users by email prefix.
  /// Returns empty list if email is less than 5 characters.
  Future<List<AppUser>> searchUsersByEmail(String email);

  /// Get the friends list for a user.
  /// If [uid] is empty, defaults to the current user.
  Future<List<AppUser>> getFriendsOfUser([String uid = '']);

  /// Add a user to the current user's friends list.
  Future<void> addFriend(String targetUid);

  /// Remove a user from the current user's friends list.
  Future<void> removeFriend(String targetUid);

  /// Remove a friend with cascade deletion.
  /// Removes from both users' friends lists AND revokes all calendar sharing
  /// between the two users.
  Future<void> removeFriendWithCascade(String targetUid);

  /// Update the display name for the current user.
  Future<void> updateDisplayName(String newDisplayName);

  /// Delete the current user's account and all associated data.
  /// Performs cascade deletion of owned calendars, shared references, etc.
  Future<void> deleteUserAccount();
}
