// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';
import 'package:timeshare/data/repo/firebase_repo.dart';
import 'package:timeshare/data/repo/user_repo.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/providers/user/user_providers.dart';

import '../fixtures/mock_firebase.dart';
import '../fixtures/test_data.dart';

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

  return ProviderContainer(
    overrides: [
      calendarRepositoryProvider.overrideWithValue(
        FirebaseRepository(firestore: firestore, auth: auth),
      ),
      userRepositoryProvider.overrideWithValue(
        UserRepository(firestore: firestore, auth: auth),
      ),
    ],
  );
}

/// Creates a ProviderContainer with specific mock instances.
ProviderContainer createTestContainerWithMocks({
  required FakeFirebaseFirestore firestore,
  required MockFirebaseAuth auth,
}) {
  return ProviderContainer(
    overrides: [
      calendarRepositoryProvider.overrideWithValue(
        FirebaseRepository(firestore: firestore, auth: auth),
      ),
      userRepositoryProvider.overrideWithValue(
        UserRepository(firestore: firestore, auth: auth),
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

  return ProviderScope(
    overrides: [
      calendarRepositoryProvider.overrideWithValue(
        FirebaseRepository(firestore: firestore, auth: auth),
      ),
      userRepositoryProvider.overrideWithValue(
        UserRepository(firestore: firestore, auth: auth),
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
  return ProviderScope(
    overrides: [
      calendarRepositoryProvider.overrideWithValue(
        FirebaseRepository(firestore: firestore, auth: auth),
      ),
      userRepositoryProvider.overrideWithValue(
        UserRepository(firestore: firestore, auth: auth),
      ),
    ],
    child: child,
  );
}
