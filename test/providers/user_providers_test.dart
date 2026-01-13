import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/providers/user/user_providers.dart';

import '../fixtures/test_data.dart';
import '../mocks/mock_providers.dart';

void main() {
  group('userRepositoryProvider', () {
    test('provides a UserRepository instance', () async {
      final container = createTestContainer();
      addTearDown(container.dispose);

      final repo = container.read(userRepositoryProvider);

      expect(repo, isNotNull);
    });
  });

  group('UserFriendsNotifier', () {
    test('loads friends on build', () async {
      final container = createTestContainer();
      addTearDown(container.dispose);

      final friends = await container.read(userFriendsProvider.future);

      expect(friends, isA<List>());
    });

    test('returns empty when signed out', () async {
      final container = createTestContainer(signedIn: false);
      addTearDown(container.dispose);

      final friends = await container.read(userFriendsProvider.future);

      expect(friends, isEmpty);
    });
  });

  group('userSearchProvider', () {
    test('returns matches for valid query', () async {
      final container = createTestContainer();
      addTearDown(container.dispose);

      final results = await container.read(
        userSearchProvider('friend@').future,
      );

      expect(results.isNotEmpty, true);
    });

    test('returns empty for short query', () async {
      final container = createTestContainer();
      addTearDown(container.dispose);

      final results = await container.read(
        userSearchProvider('abc').future,
      );

      expect(results, isEmpty);
    });

    test('returns empty for empty query', () async {
      final container = createTestContainer();
      addTearDown(container.dispose);

      final results = await container.read(
        userSearchProvider('').future,
      );

      expect(results, isEmpty);
    });
  });

  group('CurrentUserNotifier', () {
    test('loads current user on build', () async {
      final container = createTestContainer();
      addTearDown(container.dispose);

      final user = await container.read(currentUserProvider.future);

      expect(user, isNotNull);
      expect(user!.uid, TestData.testUser.uid);
    });

    test('returns null when signed out', () async {
      final container = createTestContainer(signedIn: false);
      addTearDown(container.dispose);

      final user = await container.read(currentUserProvider.future);

      expect(user, isNull);
    });
  });
}
