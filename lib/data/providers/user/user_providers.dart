import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeshare/data/repo/user_repo.dart';
import 'package:timeshare/data/models/user/app_user.dart';

part 'user_providers.g.dart';

@riverpod
UserRepository userRepository(Ref ref) => UserRepository();

@riverpod
class UserFriendsNotifier extends _$UserFriendsNotifier {
  @override
  Future<List<AppUser>> build() async {
    // Keep provider alive to prevent disposal when not watched
    ref.keepAlive();
    final repo = ref.read(userRepositoryProvider);
    return await repo.getFriendsOfUser();
  }

  void addFriend({required String targetUid}) async {
    final repo = ref.read(userRepositoryProvider);
    try {
      final newFriend = await repo.getUserById(targetUid);
      if (newFriend == null) throw Exception;
      state = AsyncValue.data([
        if (state.value != null) ...state.requireValue,
        newFriend,
      ]);
    } catch (e) {
      print('failed to add friend $targetUid');
    }
  }

  void removeFriend({required String targetUid}) async {
    final repo = ref.read(userRepositoryProvider);
    final previousState = state;
    state = AsyncValue.data(
      state.requireValue.where((friend) => friend.uid != targetUid).toList(),
    );

    try {
      await repo.removeFriend(targetUid);
      print('Friend $targetUid removed!');
    } catch (e) {
      print('Failed to remove friend $targetUid');
      state = previousState;
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
    final repo = ref.watch(userRepositoryProvider);
    return await repo.currentUser;
  }

  Future<void> updateDisplayName(String newDisplayName) async {
    final repo = ref.read(userRepositoryProvider);
    final currentUid = repo.currentUserId;
    if (currentUid == null) return;

    try {
      await repo.updateDisplayName(newDisplayName);
      // Refresh the current user data
      ref.invalidateSelf();
    } catch (e) {
      print('Failed to update display name: $e');
      rethrow;
    }
  }
}
