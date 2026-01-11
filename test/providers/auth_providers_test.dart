import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';

import '../fixtures/test_data.dart';

void main() {
  group('Auth Providers', () {
    group('authProvider', () {
      test('returns FirebaseAuth instance', () {
        final mockAuth = MockFirebaseAuth(signedIn: true);
        final container = ProviderContainer(
          overrides: [authProvider.overrideWithValue(mockAuth)],
        );
        addTearDown(container.dispose);

        final auth = container.read(authProvider);

        expect(auth, equals(mockAuth));
      });
    });

    group('currentUserIdProvider', () {
      test('returns user UID when signed in', () {
        final mockUser = MockUser(
          uid: TestData.testUser.uid,
          email: TestData.testUser.email,
        );
        final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
        final container = ProviderContainer(
          overrides: [authProvider.overrideWithValue(mockAuth)],
        );
        addTearDown(container.dispose);

        final userId = container.read(currentUserIdProvider);

        expect(userId, equals(TestData.testUser.uid));
      });

      test('returns null when signed out', () {
        final mockAuth = MockFirebaseAuth(signedIn: false);
        final container = ProviderContainer(
          overrides: [authProvider.overrideWithValue(mockAuth)],
        );
        addTearDown(container.dispose);

        final userId = container.read(currentUserIdProvider);

        expect(userId, isNull);
      });
    });

    group('authStateProvider', () {
      test('emits user when signed in', () async {
        final mockUser = MockUser(
          uid: TestData.testUser.uid,
          email: TestData.testUser.email,
        );
        final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
        final container = ProviderContainer(
          overrides: [authProvider.overrideWithValue(mockAuth)],
        );

        try {
          // Listen to the stream and wait for first value
          final subscription = container.listen(
            authStateProvider,
            (_, __) {},
            fireImmediately: true,
          );

          // Wait for stream to emit
          await Future.delayed(const Duration(milliseconds: 100));

          final authState = container.read(authStateProvider);

          expect(authState.hasValue, isTrue);
          expect(authState.value, isNotNull);
          expect(authState.value!.uid, equals(TestData.testUser.uid));

          subscription.close();
        } finally {
          container.dispose();
        }
      });

      test('emits null when signed out', () async {
        final mockAuth = MockFirebaseAuth(signedIn: false);
        final container = ProviderContainer(
          overrides: [authProvider.overrideWithValue(mockAuth)],
        );

        try {
          // Listen to the stream and wait for first value
          final subscription = container.listen(
            authStateProvider,
            (_, __) {},
            fireImmediately: true,
          );

          // Wait for stream to emit
          await Future.delayed(const Duration(milliseconds: 100));

          final authState = container.read(authStateProvider);

          expect(authState.hasValue, isTrue);
          expect(authState.value, isNull);

          subscription.close();
        } finally {
          container.dispose();
        }
      });

      test('updates when auth state changes', () async {
        final mockUser = MockUser(
          uid: TestData.testUser.uid,
          email: TestData.testUser.email,
        );
        final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
        final container = ProviderContainer(
          overrides: [authProvider.overrideWithValue(mockAuth)],
        );

        try {
          // Listen to keep provider alive
          final subscription = container.listen(
            authStateProvider,
            (_, __) {},
            fireImmediately: true,
          );

          // Wait for initial state
          await Future.delayed(const Duration(milliseconds: 100));

          // Initial state - signed in
          expect(container.read(authStateProvider).value, isNotNull);

          // Sign out
          await mockAuth.signOut();

          // Wait for stream to update
          await Future.delayed(const Duration(milliseconds: 100));

          expect(container.read(authStateProvider).value, isNull);

          subscription.close();
        } finally {
          container.dispose();
        }
      });
    });

    group('signOutProvider', () {
      test('returns a function that signs out', () async {
        final mockUser = MockUser(
          uid: TestData.testUser.uid,
          email: TestData.testUser.email,
        );
        final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
        final container = ProviderContainer(
          overrides: [authProvider.overrideWithValue(mockAuth)],
        );
        addTearDown(container.dispose);

        // Verify initially signed in
        expect(mockAuth.currentUser, isNotNull);

        // Get sign out function and call it
        final signOutFn = container.read(signOutProvider);
        await signOutFn();

        // Verify signed out
        expect(mockAuth.currentUser, isNull);
      });
    });

    group('provider integration', () {
      test('currentUserIdProvider updates after sign out', () async {
        final mockUser = MockUser(
          uid: TestData.testUser.uid,
          email: TestData.testUser.email,
        );
        final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
        final container = ProviderContainer(
          overrides: [authProvider.overrideWithValue(mockAuth)],
        );
        addTearDown(container.dispose);

        // Initially has user ID
        expect(container.read(currentUserIdProvider), equals(TestData.testUser.uid));

        // Sign out
        await container.read(signOutProvider)();

        // Invalidate provider to get fresh value
        container.invalidate(currentUserIdProvider);

        // Now should be null
        expect(container.read(currentUserIdProvider), isNull);
      });
    });
  });
}
