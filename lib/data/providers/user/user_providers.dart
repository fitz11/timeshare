import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeshare/data/repo/user_repo.dart';
import 'package:timeshare/data/models/user/app_user.dart';

part 'user_providers.g.dart';

@riverpod
UserRepository userRepository(Ref ref) => UserRepository();

@riverpod
Future<AppUser?> currentUser(Ref ref) =>
    ref.watch(userRepositoryProvider).currentUser;

@riverpod
class UserFriendsNotifier extends _$UserFriendsNotifier {
  @override
  Future<List<AppUser>> build() async {
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
