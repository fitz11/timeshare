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

// final authStateProvider = StreamProvider<User?>((ref) {
//   final auth = ref.watch(firebaseAuthProvider);
//   return auth.authStateChanges();
// });
