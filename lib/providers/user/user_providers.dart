import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeshare/data/repo/user_repo.dart';
import 'package:timeshare/data/repo/logged_user_repo.dart';
import 'package:timeshare/data/models/user/app_user.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/services/logging/app_logger.dart';

part 'user_providers.g.dart';

@riverpod
LoggedUserRepository userRepository(Ref ref) {
  final calendarRepo = ref.watch(calendarRepositoryProvider);
  return LoggedUserRepository(
    UserRepository(calendarRepo: calendarRepo),
    AppLogger(),
  );
}

@riverpod
class UserFriendsNotifier extends _$UserFriendsNotifier {
  @override
  Future<List<AppUser>> build() async {
    ref.keepAlive();

    // Invalidate when auth state changes (logout/login)
    ref.listen(authStateProvider, (prev, next) {
      ref.invalidateSelf();
    });

    final repo = ref.read(userRepositoryProvider);
    return await repo.getFriendsOfUser();
  }

  /// Add a friend with proper error handling.
  /// Returns normally on success, surfaces error to UI on failure.
  Future<void> addFriend({required String targetUid}) async {
    final repo = ref.read(userRepositoryProvider);
    final previousState = state;

    try {
      final newFriend = await repo.getUserById(targetUid);
      if (newFriend == null) throw Exception('User not found');

      // Optimistic update
      final currentFriends = state.value ?? [];
      state = AsyncValue.data([...currentFriends, newFriend]);

      // Persist to backend
      await repo.addFriend(targetUid);
    } catch (e, st) {
      state = previousState; // Rollback on failure
      state = AsyncValue.error(e, st); // Surface error to UI
    }
  }

  /// Remove a friend with proper error handling and rollback.
  Future<void> removeFriend({required String targetUid}) async {
    final repo = ref.read(userRepositoryProvider);
    final previousState = state;

    // Safe state access
    final currentFriends = state.value;
    if (currentFriends == null) return;

    // Optimistic update
    state = AsyncValue.data(
      currentFriends.where((friend) => friend.uid != targetUid).toList(),
    );

    try {
      await repo.removeFriend(targetUid);
    } catch (e, st) {
      state = previousState; // Rollback on failure
      state = AsyncValue.error(e, st); // Surface error to UI
    }
  }
}

@riverpod
Future<List<AppUser>> userSearch(Ref ref, String email) async =>
    await ref.watch(userRepositoryProvider).searchUsersByEmail(email);

@riverpod
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  Future<AppUser?> build() async {
    ref.keepAlive();

    // Invalidate when auth state changes (logout/login)
    ref.listen(authStateProvider, (prev, next) {
      ref.invalidateSelf();
    });

    // Use ref.read() - we only need the repo once, not reactive dependency
    final repo = ref.read(userRepositoryProvider);
    return await repo.currentUser;
  }

  /// Update display name with proper error handling.
  Future<void> updateDisplayName(String newDisplayName) async {
    final repo = ref.read(userRepositoryProvider);
    final currentUid = repo.currentUserId;
    if (currentUid == null) return;

    final previousState = state;

    try {
      // Optimistic update
      final currentUser = state.value;
      if (currentUser != null) {
        state = AsyncValue.data(
          currentUser.copyWith(displayName: newDisplayName),
        );
      }

      await repo.updateDisplayName(newDisplayName);
    } catch (e, st) {
      state = previousState; // Rollback on failure
      state = AsyncValue.error(e, st); // Surface error to UI
    }
  }

  /// Delete the current user's account and all associated data.
  /// This performs cascade deletion of calendars, events, and user data.
  Future<void> deleteAccount() async {
    final repo = ref.read(userRepositoryProvider);

    try {
      await repo.deleteUserAccount();
      // Auth state change will trigger invalidation
    } catch (e, st) {
      state = AsyncValue.error(e, st); // Surface error to UI
    }
  }
}
