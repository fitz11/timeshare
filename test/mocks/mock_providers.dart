import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/repo/firebase_repo.dart';
import 'package:timeshare/data/repo/logged_user_repo.dart';
import 'package:timeshare/data/repo/user_repo.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/providers/user/user_providers.dart';
import 'package:timeshare/services/logging/app_logger.dart';

import '../fixtures/mock_firebase.dart';

/// Creates a ProviderContainer with mocked Firebase services.
/// Useful for unit testing providers.
Future<ProviderContainer> createTestContainer({
  bool signedIn = true,
  bool seedData = true,
}) async {
  final auth = MockFirebaseSetup.createMockAuth(signedIn: signedIn);
  final firestore = seedData
      ? await MockFirebaseSetup.createSeededFirestore()
      : MockFirebaseSetup.createFakeFirestore();

  final calendarRepo = FirebaseRepository(firestore: firestore, auth: auth);

  return ProviderContainer(
    overrides: [
      calendarRepositoryProvider.overrideWithValue(calendarRepo),
      userRepositoryProvider.overrideWithValue(
        LoggedUserRepository(
          UserRepository(
            firestore: firestore,
            auth: auth,
            calendarRepo: calendarRepo,
          ),
          AppLogger(),
        ),
      ),
    ],
  );
}

/// Creates a ProviderContainer with specific mock instances.
ProviderContainer createTestContainerWithMocks({
  required FakeFirebaseFirestore firestore,
  required MockFirebaseAuth auth,
}) {
  final calendarRepo = FirebaseRepository(firestore: firestore, auth: auth);

  return ProviderContainer(
    overrides: [
      calendarRepositoryProvider.overrideWithValue(calendarRepo),
      userRepositoryProvider.overrideWithValue(
        LoggedUserRepository(
          UserRepository(
            firestore: firestore,
            auth: auth,
            calendarRepo: calendarRepo,
          ),
          AppLogger(),
        ),
      ),
    ],
  );
}

/// Creates a ProviderScope widget wrapper for widget tests.
Future<ProviderScope> createTestProviderScope({
  required Widget child,
  bool signedIn = true,
  bool seedData = true,
}) async {
  final auth = MockFirebaseSetup.createMockAuth(signedIn: signedIn);
  final firestore = seedData
      ? await MockFirebaseSetup.createSeededFirestore()
      : MockFirebaseSetup.createFakeFirestore();

  final calendarRepo = FirebaseRepository(firestore: firestore, auth: auth);

  return ProviderScope(
    overrides: [
      calendarRepositoryProvider.overrideWithValue(calendarRepo),
      userRepositoryProvider.overrideWithValue(
        LoggedUserRepository(
          UserRepository(
            firestore: firestore,
            auth: auth,
            calendarRepo: calendarRepo,
          ),
          AppLogger(),
        ),
      ),
    ],
    child: child,
  );
}

/// Creates a ProviderScope with specific mock instances for widget tests.
ProviderScope createTestProviderScopeWithMocks({
  required Widget child,
  required FakeFirebaseFirestore firestore,
  required MockFirebaseAuth auth,
}) {
  final calendarRepo = FirebaseRepository(firestore: firestore, auth: auth);

  return ProviderScope(
    overrides: [
      calendarRepositoryProvider.overrideWithValue(calendarRepo),
      userRepositoryProvider.overrideWithValue(
        LoggedUserRepository(
          UserRepository(
            firestore: firestore,
            auth: auth,
            calendarRepo: calendarRepo,
          ),
          AppLogger(),
        ),
      ),
    ],
    child: child,
  );
}
