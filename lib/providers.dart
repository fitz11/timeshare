import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/calendar/calendar.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';
import 'package:timeshare/data/repo/user_repo.dart';
import 'package:timeshare/data/user/app_user.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});

//homepage nav provider; defaults to calendar page
final bottomNavIndexProvider = StateProvider<int>((ref) => 1);

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
  final repo = ref.read(userRepositoryProvider);
  final uid = repo.currentUserId;
  if (uid == null) return [];
  return await repo.getFriendsOfUser(uid);
});

final userSearchProvider = FutureProvider.family<AppUser?, String>((
  ref,
  email,
) {
  final repo = ref.read(userRepositoryProvider);
  return repo.findUserByEmail(email);
});

class CalendarNotifier extends StateNotifier<List<Calendar>> {
  final CalendarRepository repo;
  CalendarNotifier(this.repo) : super([]);

  Future<void> loadCalendars({String? uid}) async {
    final calendars = await repo.getAllAvailableCalendars(uid: uid);
    state = calendars;
  }
}

final calendarNotifierProvider =
    StateNotifierProvider<CalendarNotifier, List<Calendar>>((ref) {
      return CalendarNotifier(CalendarRepository());
    });
