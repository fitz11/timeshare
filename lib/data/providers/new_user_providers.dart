import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeshare/data/repo/user_repo.dart';
import 'package:timeshare/data/user/app_user.dart';

part 'new_user_providers.g.dart';

@riverpod
UserRepository userRepository(Ref ref) => UserRepository();

@riverpod
Future<AppUser?> currentUser(Ref ref) =>
    ref.watch(userRepositoryProvider).currentUser;

@riverpod
class UserFriendsNotifier extends _$UserFriendsNotifier {
  late final UserRepository _repo;
  late final AppUser? _currentUser;

  @override
  Future<List<AppUser>> build() async {
    _repo = ref.watch(userRepositoryProvider);
    _currentUser = ref.watch(currentUserProvider).requireValue;
    return await _repo.getFriendsOfUser(_currentUser!.uid);
  }

  void addFriend({required String targetUid}) async {
    try {
      final newFriend = await _repo.getUserById(targetUid);
      final friend = newFriend!;
      state = AsyncValue.data([
        if (state.valueOrNull != null) ...state.requireValue,
        friend,
      ]);
    } catch (e) {
      print('failed to add friend $targetUid');
    }
  }

  void removeFriend({required String targetUid}) async {
    final previousState = state;
    state = AsyncValue.data(
      state.requireValue.where((friend) => friend.uid != targetUid).toList(),
    );

    try {
      await _repo.removeFriend(targetUid);
      print('Friend $targetUid removed!');
    } catch (e) {
      print('Failed to remove friend $targetUid');
      state = previousState;
    }
  }
}

@riverpod
Future<List<AppUser>> userSearch(Ref ref, String email) async =>
    await ref.watch(userRepositoryProvider).searchUserByEmail(email);
