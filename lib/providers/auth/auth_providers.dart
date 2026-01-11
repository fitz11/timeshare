import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

@riverpod
FirebaseAuth auth(Ref ref) => FirebaseAuth.instance;

@riverpod
Stream<User?> authState(Ref ref) => ref.watch(authProvider).authStateChanges();

/// Current user ID - synchronous access to the current user's UID.
/// Returns null if not logged in.
@riverpod
String? currentUserId(Ref ref) => ref.watch(authProvider).currentUser?.uid;

/// Sign out the current user.
@riverpod
Future<void> Function() signOut(Ref ref) {
  return () => ref.read(authProvider).signOut();
}
