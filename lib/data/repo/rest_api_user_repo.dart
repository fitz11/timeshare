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
    if (email.isEmpty || email.length < 5) {
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
  Future<void> addFriend(String targetUid) async {
    final currentUid = currentUserId;
    if (currentUid == null) return;

    await _client.post('/api/v1/timeshare/users/$currentUid/friends/$targetUid/');
  }

  @override
  Future<void> removeFriend(String targetUid) async {
    final currentUid = currentUserId;
    if (currentUid == null) return;

    await _client.delete('/api/v1/timeshare/users/$currentUid/friends/$targetUid/');
  }

  @override
  Future<void> updateDisplayName(String newDisplayName) async {
    final currentUid = currentUserId;
    if (currentUid == null) return;

    await _client.patch(
      '/api/v1/timeshare/users/$currentUid/',
      body: jsonEncode({'display_name': newDisplayName}),
    );
  }

  @override
  Future<void> deleteUserAccount() async {
    final currentUid = currentUserId;
    if (currentUid == null) {
      throw Exception('You must be logged in to delete your account.');
    }

    // Delete all owned calendars first (cascade deletion)
    // The backend should handle this, but we do it client-side for consistency
    final calendars = await _calendarRepo.getAllAvailableCalendars(uid: currentUid);
    for (final calendar in calendars) {
      if (calendar.owner == currentUid) {
        await _calendarRepo.deleteCalendar(calendar.id);
      }
    }

    // Delete user account via API
    await _client.delete('/api/v1/timeshare/users/$currentUid/');

    // Sign out locally
    await _authService.logout();
  }
}
