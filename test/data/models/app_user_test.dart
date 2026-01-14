import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/models/user/app_user.dart';

void main() {
  group('AppUser', () {
    test('creates user with required fields', () {
      final user = AppUser(
        uid: 'user123',
        email: 'test@example.com',
        displayName: 'Test User',
        joinedAt: DateTime(2024, 1, 15),
      );

      expect(user.uid, 'user123');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.joinedAt, DateTime(2024, 1, 15));
    });

    test('has default isAdmin of false', () {
      final user = AppUser(
        uid: 'user123',
        email: 'test@example.com',
        displayName: 'Test User',
        joinedAt: DateTime(2024, 1, 15),
      );

      expect(user.isAdmin, false);
    });

    test('has default empty friends list', () {
      final user = AppUser(
        uid: 'user123',
        email: 'test@example.com',
        displayName: 'Test User',
        joinedAt: DateTime(2024, 1, 15),
      );

      expect(user.friends, isEmpty);
    });

    test('creates user with all fields', () {
      final user = AppUser(
        uid: 'admin123',
        email: 'admin@example.com',
        displayName: 'Admin User',
        photoUrl: 'https://example.com/photo.jpg',
        isAdmin: true,
        joinedAt: DateTime(2024, 1, 1),
        friends: ['friend1', 'friend2'],
      );

      expect(user.photoUrl, 'https://example.com/photo.jpg');
      expect(user.isAdmin, true);
      expect(user.friends, ['friend1', 'friend2']);
    });

    test('photoUrl defaults to null', () {
      final user = AppUser(
        uid: 'user123',
        email: 'test@example.com',
        displayName: 'Test User',
        joinedAt: DateTime(2024, 1, 15),
      );

      expect(user.photoUrl, isNull);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = AppUser(
        uid: 'user123',
        email: 'test@example.com',
        displayName: 'Original Name',
        joinedAt: DateTime(2024, 1, 15),
      );

      final updated = original.copyWith(displayName: 'New Name');

      expect(updated.displayName, 'New Name');
      expect(updated.uid, original.uid);
      expect(updated.email, original.email);
    });

    test('copyWith can update friends list', () {
      final original = AppUser(
        uid: 'user123',
        email: 'test@example.com',
        displayName: 'Test User',
        joinedAt: DateTime(2024, 1, 15),
        friends: ['friend1'],
      );

      final updated = original.copyWith(friends: ['friend1', 'friend2']);

      expect(updated.friends, ['friend1', 'friend2']);
    });

    test('equality works correctly', () {
      final user1 = AppUser(
        uid: 'user123',
        email: 'test@example.com',
        displayName: 'Test User',
        joinedAt: DateTime(2024, 1, 15),
      );

      final user2 = AppUser(
        uid: 'user123',
        email: 'test@example.com',
        displayName: 'Test User',
        joinedAt: DateTime(2024, 1, 15),
      );

      expect(user1, user2);
    });

    test('inequality for different uids', () {
      final user1 = AppUser(
        uid: 'user123',
        email: 'test@example.com',
        displayName: 'Test User',
        joinedAt: DateTime(2024, 1, 15),
      );

      final user2 = AppUser(
        uid: 'user456',
        email: 'test@example.com',
        displayName: 'Test User',
        joinedAt: DateTime(2024, 1, 15),
      );

      expect(user1, isNot(user2));
    });

    test('toJson serializes user', () {
      final user = AppUser(
        uid: 'user123',
        email: 'test@example.com',
        displayName: 'Test User',
        isAdmin: true,
        joinedAt: DateTime.utc(2024, 1, 15),
        friends: ['friend1'],
      );

      final json = user.toJson();

      expect(json['uid'], 'user123');
      expect(json['email'], 'test@example.com');
      expect(json['displayName'], 'Test User');
      expect(json['isAdmin'], true);
      expect(json['friends'], ['friend1']);
    });

    test('fromJson deserializes user', () {
      final json = {
        'uid': 'user123',
        'email': 'test@example.com',
        'displayName': 'From JSON',
        'photoUrl': null,
        'isAdmin': false,
        'dateJoined': DateTime.utc(2024, 1, 15),
        'friends': <String>[],
      };

      final user = AppUser.fromJson(json);

      expect(user.uid, 'user123');
      expect(user.displayName, 'From JSON');
    });

    test('handles friends list operations', () {
      final user = AppUser(
        uid: 'user123',
        email: 'test@example.com',
        displayName: 'Test User',
        joinedAt: DateTime(2024, 1, 15),
        friends: ['friend1', 'friend2', 'friend3'],
      );

      expect(user.friends.length, 3);
      expect(user.friends.contains('friend2'), true);
    });
  });
}
