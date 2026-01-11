// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/user/app_user.dart';

import 'test_data.dart';

/// Helper class for setting up Firebase mocks in tests.
class MockFirebaseSetup {
  /// Creates a mock FirebaseAuth instance.
  /// [signedIn] determines if a user is signed in.
  static MockFirebaseAuth createMockAuth({bool signedIn = true}) {
    if (signedIn) {
      final mockUser = MockUser(
        uid: TestData.testUser.uid,
        email: TestData.testUser.email,
        displayName: TestData.testUser.displayName,
      );
      return MockFirebaseAuth(mockUser: mockUser, signedIn: true);
    }
    return MockFirebaseAuth(signedIn: false);
  }

  /// Creates an empty FakeFirebaseFirestore instance.
  static FakeFirebaseFirestore createFakeFirestore() {
    return FakeFirebaseFirestore();
  }

  /// Creates a FakeFirebaseFirestore seeded with test data.
  static Future<FakeFirebaseFirestore> createSeededFirestore() async {
    final firestore = FakeFirebaseFirestore();

    // Seed users
    await firestore.collection('users').doc(TestData.testUser.uid).set({
      'uid': TestData.testUser.uid,
      'email': TestData.testUser.email,
      'displayName': TestData.testUser.displayName,
      'photoUrl': TestData.testUser.photoUrl,
      'isAdmin': TestData.testUser.isAdmin,
      'joinedAt': Timestamp.fromDate(TestData.testUser.joinedAt),
      'friends': TestData.testUser.friends,
    });

    await firestore.collection('users').doc(TestData.friendUser.uid).set({
      'uid': TestData.friendUser.uid,
      'email': TestData.friendUser.email,
      'displayName': TestData.friendUser.displayName,
      'photoUrl': TestData.friendUser.photoUrl,
      'isAdmin': TestData.friendUser.isAdmin,
      'joinedAt': Timestamp.fromDate(TestData.friendUser.joinedAt),
      'friends': TestData.friendUser.friends,
    });

    await firestore.collection('users').doc(TestData.otherUser.uid).set({
      'uid': TestData.otherUser.uid,
      'email': TestData.otherUser.email,
      'displayName': TestData.otherUser.displayName,
      'photoUrl': TestData.otherUser.photoUrl,
      'isAdmin': TestData.otherUser.isAdmin,
      'joinedAt': Timestamp.fromDate(TestData.otherUser.joinedAt),
      'friends': TestData.otherUser.friends,
    });

    // Seed calendars
    await firestore
        .collection('calendars')
        .doc(TestData.testCalendar.id)
        .set(TestData.testCalendar.toJson());

    await firestore
        .collection('calendars')
        .doc(TestData.emptyCalendar.id)
        .set(TestData.emptyCalendar.toJson());

    await firestore
        .collection('calendars')
        .doc(TestData.sharedCalendar.id)
        .set(TestData.sharedCalendar.toJson());

    return firestore;
  }

  /// Creates a minimal seeded firestore for specific test scenarios.
  static Future<FakeFirebaseFirestore> createMinimalFirestore({
    List<Calendar>? calendars,
    List<AppUser>? users,
  }) async {
    final firestore = FakeFirebaseFirestore();

    if (users != null) {
      for (final user in users) {
        await firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
          'isAdmin': user.isAdmin,
          'joinedAt': Timestamp.fromDate(user.joinedAt),
          'friends': user.friends,
        });
      }
    }

    if (calendars != null) {
      for (final calendar in calendars) {
        await firestore
            .collection('calendars')
            .doc(calendar.id)
            .set(calendar.toJson());
      }
    }

    return firestore;
  }
}
