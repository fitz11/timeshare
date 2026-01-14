// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/repo/rest_api_user_repo.dart';
import 'package:timeshare/data/repo/logged_user_repo.dart';
import 'package:timeshare/data/models/user/app_user.dart';
import 'package:timeshare/data/services/api_client.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/providers/config/config_providers.dart';
import 'package:timeshare/services/logging/app_logger.dart';

/// User repository provider - uses REST API.
final userRepositoryProvider = Provider<LoggedUserRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  final authService = ref.watch(authServiceProvider);
  final calendarRepo = ref.watch(calendarRepositoryProvider);
  final logger = ref.watch(appLoggerProvider);

  final apiClient = HttpApiClient(
    baseUrl: config.apiBaseUrl,
    getApiKey: () => authService.apiKey,
  );

  return LoggedUserRepository(
    RestApiUserRepository(
      client: apiClient,
      authService: authService,
      calendarRepo: calendarRepo,
    ),
    logger,
  );
});

/// User friends notifier with optimistic updates.
class UserFriendsNotifier extends AsyncNotifier<List<AppUser>> {
  @override
  Future<List<AppUser>> build() async {
    ref.keepAlive();

    ref.listen(authStateProvider, (prev, next) {
      ref.invalidateSelf();
    });

    final repo = ref.read(userRepositoryProvider);
    return await repo.getFriendsOfUser();
  }

  Future<void> addFriend({required String targetUid}) async {
    final repo = ref.read(userRepositoryProvider);
    final previousState = state;

    try {
      final newFriend = await repo.getUserById(targetUid);
      if (newFriend == null) throw Exception('User not found');

      final currentFriends = state.value ?? [];
      state = AsyncValue.data([...currentFriends, newFriend]);

      await repo.addFriend(targetUid);
    } catch (e, st) {
      state = previousState;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeFriend({required String targetUid}) async {
    final repo = ref.read(userRepositoryProvider);
    final previousState = state;

    final currentFriends = state.value;
    if (currentFriends == null) return;

    state = AsyncValue.data(
      currentFriends.where((friend) => friend.uid != targetUid).toList(),
    );

    try {
      await repo.removeFriend(targetUid);
    } catch (e, st) {
      state = previousState;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeFriendWithCascade({required String targetUid}) async {
    final repo = ref.read(userRepositoryProvider);
    final previousState = state;

    final currentFriends = state.value;
    if (currentFriends == null) return;

    state = AsyncValue.data(
      currentFriends.where((friend) => friend.uid != targetUid).toList(),
    );

    try {
      await repo.removeFriendWithCascade(targetUid);
      ref.invalidate(calendarsProvider);
    } catch (e, st) {
      state = previousState;
      state = AsyncValue.error(e, st);
    }
  }
}

final userFriendsProvider =
    AsyncNotifierProvider<UserFriendsNotifier, List<AppUser>>(
  UserFriendsNotifier.new,
);

/// Search users by email.
final userSearchProvider =
    FutureProvider.family<List<AppUser>, String>((ref, email) async {
  const tag = 'UserSearch';
  final trimmed = email.trim();

  if (trimmed.length < 5) {
    AppLogger().warning('skipped - query too short: "$trimmed" (${trimmed.length} chars)', tag: tag);
    return [];
  }

  AppLogger().warning('searching for: "$trimmed"', tag: tag);
  final results = await ref.read(userRepositoryProvider).searchUsersByEmail(email);
  AppLogger().warning('found ${results.length} results for: "$trimmed"', tag: tag);
  return results;
});

/// Current user notifier with profile management.
class CurrentUserNotifier extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    ref.keepAlive();

    ref.listen(authStateProvider, (prev, next) {
      ref.invalidateSelf();
    });

    final repo = ref.read(userRepositoryProvider);
    return await repo.currentUser;
  }

  Future<void> updateDisplayName(String newDisplayName) async {
    final repo = ref.read(userRepositoryProvider);
    final currentUid = repo.currentUserId;
    if (currentUid == null) return;

    final previousState = state;

    try {
      final currentUser = state.value;
      if (currentUser != null) {
        state = AsyncValue.data(
          currentUser.copyWith(displayName: newDisplayName),
        );
      }

      await repo.updateDisplayName(newDisplayName);
    } catch (e, st) {
      state = previousState;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAccount() async {
    final repo = ref.read(userRepositoryProvider);

    try {
      await repo.deleteUserAccount();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final currentUserProvider = AsyncNotifierProvider<CurrentUserNotifier, AppUser?>(
  CurrentUserNotifier.new,
);
