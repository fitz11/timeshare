// Timeshare: a cross-platform app to make and share calendars.
// Copyright (C) 2025  David Fitzsimmons
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
