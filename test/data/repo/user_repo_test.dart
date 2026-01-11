// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/repo/user_repo.dart';

import '../../fixtures/mock_firebase.dart';
import '../../fixtures/test_data.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late UserRepository repo;

  setUp(() async {
    firestore = await MockFirebaseSetup.createSeededFirestore();
    auth = MockFirebaseSetup.createMockAuth(signedIn: true);
    repo = UserRepository(firestore: firestore, auth: auth);
  });

  group('UserRepository - currentUserId', () {
    test('returns uid when signed in', () {
      expect(repo.currentUserId, TestData.testUser.uid);
    });

    test('returns null when signed out', () {
      final signedOutAuth = MockFirebaseSetup.createMockAuth(signedIn: false);
      final signedOutRepo = UserRepository(
        firestore: firestore,
        auth: signedOutAuth,
      );

      expect(signedOutRepo.currentUserId, isNull);
    });
  });

  group('UserRepository - currentUser', () {
    test('returns user when signed in', () async {
      final user = await repo.currentUser;

      expect(user, isNotNull);
      expect(user!.uid, TestData.testUser.uid);
    });

    test('returns null when signed out', () async {
      final signedOutAuth = MockFirebaseSetup.createMockAuth(signedIn: false);
      final signedOutRepo = UserRepository(
        firestore: firestore,
        auth: signedOutAuth,
      );

      final user = await signedOutRepo.currentUser;

      expect(user, isNull);
    });
  });

  group('UserRepository - getUserById', () {
    test('returns user when found', () async {
      final user = await repo.getUserById(TestData.friendUser.uid);

      expect(user, isNotNull);
      expect(user!.email, TestData.friendUser.email);
    });

    test('returns null when not found', () async {
      final user = await repo.getUserById('nonexistent-user');

      expect(user, isNull);
    });

    test('defaults to current user when empty uid', () async {
      final user = await repo.getUserById();

      expect(user, isNotNull);
      expect(user!.uid, TestData.testUser.uid);
    });

    test('returns null when empty uid and not signed in', () async {
      final signedOutAuth = MockFirebaseSetup.createMockAuth(signedIn: false);
      final signedOutRepo = UserRepository(
        firestore: firestore,
        auth: signedOutAuth,
      );

      final user = await signedOutRepo.getUserById();

      expect(user, isNull);
    });
  });

  group('UserRepository - searchUsersByEmail', () {
    test('returns matching users', () async {
      final results = await repo.searchUsersByEmail('friend@');

      expect(results.isNotEmpty, true);
      expect(results.any((u) => u.email == TestData.friendUser.email), true);
    });

    test('returns empty for short query', () async {
      final results = await repo.searchUsersByEmail('abc');

      expect(results, isEmpty);
    });

    test('returns empty for empty query', () async {
      final results = await repo.searchUsersByEmail('');

      expect(results, isEmpty);
    });

    test('returns empty when no matches', () async {
      final results = await repo.searchUsersByEmail('nonexistent@email.com');

      expect(results, isEmpty);
    });
  });

  group('UserRepository - getFriendsOfUser', () {
    test('returns friends list', () async {
      final friends = await repo.getFriendsOfUser();

      expect(friends.isNotEmpty, true);
    });

    test('returns empty when user has no friends', () async {
      final friends = await repo.getFriendsOfUser(TestData.otherUser.uid);

      expect(friends, isEmpty);
    });

    test('returns empty when not signed in and no uid provided', () async {
      final signedOutAuth = MockFirebaseSetup.createMockAuth(signedIn: false);
      final signedOutRepo = UserRepository(
        firestore: firestore,
        auth: signedOutAuth,
      );

      final friends = await signedOutRepo.getFriendsOfUser();

      expect(friends, isEmpty);
    });
  });

  group('UserRepository - addFriend', () {
    test('adds friend to friends array', () async {
      await repo.addFriend(TestData.otherUser.uid);

      final doc = await firestore
          .collection('users')
          .doc(TestData.testUser.uid)
          .get();

      final friends = List<String>.from(doc.data()?['friends'] ?? []);
      expect(friends.contains(TestData.otherUser.uid), true);
    });

    test('does nothing when not signed in', () async {
      final signedOutAuth = MockFirebaseSetup.createMockAuth(signedIn: false);
      final signedOutRepo = UserRepository(
        firestore: firestore,
        auth: signedOutAuth,
      );

      // Should not throw, just return early
      await signedOutRepo.addFriend('some-user');
    });
  });

  group('UserRepository - removeFriend', () {
    test('removes friend from friends array', () async {
      // First verify friend exists
      final beforeDoc = await firestore
          .collection('users')
          .doc(TestData.testUser.uid)
          .get();
      final friendsBefore = List<String>.from(beforeDoc.data()?['friends'] ?? []);
      expect(friendsBefore.contains(TestData.friendUser.uid), true);

      await repo.removeFriend(TestData.friendUser.uid);

      final afterDoc = await firestore
          .collection('users')
          .doc(TestData.testUser.uid)
          .get();
      final friendsAfter = List<String>.from(afterDoc.data()?['friends'] ?? []);
      expect(friendsAfter.contains(TestData.friendUser.uid), false);
    });

    test('does nothing when not signed in', () async {
      final signedOutAuth = MockFirebaseSetup.createMockAuth(signedIn: false);
      final signedOutRepo = UserRepository(
        firestore: firestore,
        auth: signedOutAuth,
      );

      // Should not throw, just return early
      await signedOutRepo.removeFriend('some-user');
    });
  });

  group('UserRepository - updateDisplayName', () {
    test('updates display name', () async {
      await repo.updateDisplayName('New Display Name');

      final doc = await firestore
          .collection('users')
          .doc(TestData.testUser.uid)
          .get();

      expect(doc.data()?['displayName'], 'New Display Name');
    });

    test('does nothing when not signed in', () async {
      final signedOutAuth = MockFirebaseSetup.createMockAuth(signedIn: false);
      final signedOutRepo = UserRepository(
        firestore: firestore,
        auth: signedOutAuth,
      );

      // Should not throw, just return early
      await signedOutRepo.updateDisplayName('Should Not Update');
    });
  });

  group('UserRepository - signInOrRegister', () {
    test('creates new user document when not exists', () async {
      // Create fresh firestore without seeded data
      final freshFirestore = MockFirebaseSetup.createFakeFirestore();
      final newUserAuth = MockFirebaseAuth(
        mockUser: MockUser(
          uid: 'brand-new-user',
          email: 'newuser@example.com',
          displayName: 'New User',
        ),
        signedIn: true,
      );
      final newRepo = UserRepository(
        firestore: freshFirestore,
        auth: newUserAuth,
      );

      await newRepo.signInOrRegister();

      final doc = await freshFirestore
          .collection('users')
          .doc('brand-new-user')
          .get();

      expect(doc.exists, true);
      expect(doc.data()?['email'], 'newuser@example.com');
    });

    test('does not overwrite existing user', () async {
      final originalDisplayName = TestData.testUser.displayName;

      await repo.signInOrRegister();

      final doc = await firestore
          .collection('users')
          .doc(TestData.testUser.uid)
          .get();

      expect(doc.data()?['displayName'], originalDisplayName);
    });

    test('uses email prefix when displayName is null', () async {
      final freshFirestore = MockFirebaseSetup.createFakeFirestore();
      final noDisplayNameAuth = MockFirebaseAuth(
        mockUser: MockUser(
          uid: 'no-display-name',
          email: 'nodisplay@example.com',
          displayName: null,
        ),
        signedIn: true,
      );
      final repo = UserRepository(
        firestore: freshFirestore,
        auth: noDisplayNameAuth,
      );

      await repo.signInOrRegister();

      final doc = await freshFirestore
          .collection('users')
          .doc('no-display-name')
          .get();

      expect(doc.data()?['displayName'], 'nodisplay');
    });
  });
}
