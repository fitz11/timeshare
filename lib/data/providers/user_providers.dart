import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/repo/user_repo.dart';
import 'package:timeshare/data/user/app_user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  final uid = repo.currentUserId;
  if (uid == null) return null;
  return await repo.getUserById(uid);
});

final userFriendsProvider = FutureProvider<List<AppUser>>((ref) async {
  print('__friends provider called__');
  final user = ref.read(currentUserProvider);
  final repo = ref.read(userRepositoryProvider);
  return await repo.getFriendsOfUser(user.value!.uid);
});

final userSearchProvider = FutureProvider.family<List<AppUser>, String>((
  ref,
  email,
) async {
  final repo = ref.read(userRepositoryProvider);
  return await repo.searchUserByEmail(email);
});
