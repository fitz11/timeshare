// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';

import 'package:timeshare/data/models/user/app_user.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';
import 'package:timeshare/data/repo/user_repo_interface.dart';
import 'package:timeshare/data/services/api_client.dart';
import 'package:timeshare/data/services/auth_service.dart';

/// REST API implementation of [UserRepositoryInterface].
///
/// Designed to work with a Django REST Framework backend.
class RestApiUserRepository implements UserRepositoryInterface {
  final ApiClient _client;
  final AuthService _authService;
  // ignore: unused_field
  final CalendarRepository _calendarRepo;

  RestApiUserRepository({
    required ApiClient client,
    required AuthService authService,
    required CalendarRepository calendarRepo,
  })  : _client = client,
        _authService = authService,
        _calendarRepo = calendarRepo;

  @override
  String? get currentUserId => _authService.currentUserId;

  @override
  Future<AppUser?> get currentUser async {
    if (currentUserId == null) return null;
    return await getUserById(currentUserId!);
  }

  @override
  Future<void> signInOrRegister() async {
    // For REST API, user registration happens at signup time via AuthService.
    // This method syncs the user profile after authentication.
    // The backend should have already created the user during auth.
    // This is a no-op for REST API - just verify the user exists.
    if (currentUserId == null) {
      throw StateError('User must be authenticated before calling signInOrRegister');
    }

    // Optionally fetch user to verify they exist
    final user = await getUserById(currentUserId!);
    if (user == null) {
      throw StateError('User profile not found after authentication');
    }
  }

  @override
  Future<AppUser?> getUserById([String uid = '']) async {
    if (uid.isEmpty && currentUserId != null) uid = currentUserId!;
    if (uid.isEmpty) return null;

    try {
      final response = await _client.get('/api/v1/timeshare/users/$uid/');
      return AppUser.fromJson(jsonDecode(response.body));
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<List<AppUser>> searchUsersByEmail(String email) async {
    // Backend requires minimum 6 characters to prevent email enumeration
    if (email.isEmpty || email.length < 6) {
      return [];
    }

    final response = await _client.get(
      '/api/v1/timeshare/users/search/?email=${Uri.encodeComponent(email)}',
    );
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => AppUser.fromJson(json)).toList();
  }

  @override
  Future<List<AppUser>> getFriendsOfUser([String uid = '']) async {
    if (uid.isEmpty && currentUserId != null) uid = currentUserId!;
    if (uid.isEmpty) return [];

    final response = await _client.get('/api/v1/timeshare/users/$uid/friends/');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => AppUser.fromJson(json)).toList();
  }

  @override
  Future<void> removeFriend(String targetUid) async {
    final currentUid = currentUserId;
    if (currentUid == null) return;

    await _client.delete('/api/v1/timeshare/users/$currentUid/friends/$targetUid/');
  }

  @override
  Future<void> removeFriendWithCascade(String targetUid) async {
    final currentUid = currentUserId;
    if (currentUid == null) return;

    // The cascade=true parameter tells the backend to:
    // 1. Remove targetUid from current user's friends list
    // 2. Remove current user from target's friends list
    // 3. Revoke all calendar sharing between the two users
    await _client.delete(
      '/api/v1/timeshare/users/$currentUid/friends/$targetUid/?cascade=true',
    );
  }

  @override
  Future<void> updateDisplayName(String newDisplayName) async {
    final currentUid = currentUserId;
    if (currentUid == null) return;

    // Note: Backend uses camelCase JSON (djangorestframework-camel-case)
    await _client.patch(
      '/api/v1/timeshare/users/$currentUid/',
      body: jsonEncode({'displayName': newDisplayName}),
    );
  }

  @override
  Future<void> deleteUserAccount() async {
    final currentUid = currentUserId;
    if (currentUid == null) {
      throw Exception('You must be logged in to delete your account.');
    }

    // Delete user account via API - backend handles cascade deletion of owned calendars
    await _client.delete('/api/v1/timeshare/users/$currentUid/');

    // Sign out locally
    await _authService.logout();
  }
}
