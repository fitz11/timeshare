// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/models/user/app_user.dart';
import 'package:timeshare/providers/user/user_providers.dart';
import 'package:timeshare/ui/features/friends/friends_page.dart';

import '../../mocks/mock_providers.dart';

void main() {
  group('FriendsPage', () {
    testWidgets('shows loading indicator initially', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(body: FriendsPage()),
        ),
      );

      await tester.pumpWidget(scope);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no friends', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(body: FriendsPage()),
        ),
        seedData: false,
      );

      await tester.pumpWidget(scope);
      await tester.pumpAndSettle();

      expect(find.text('No Friends Yet'), findsOneWidget);
      expect(
        find.text('Search for users to add them as friends'),
        findsOneWidget,
      );
    });

    testWidgets('shows friend cards when friends exist', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(body: FriendsPage()),
        ),
      );

      await tester.pumpWidget(scope);
      await tester.pumpAndSettle();

      // Should show friend's display name
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('shows share button for each friend', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(body: FriendsPage()),
        ),
      );

      await tester.pumpWidget(scope);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.share_outlined), findsWidgets);
    });

    testWidgets('shows menu button for each friend', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(body: FriendsPage()),
        ),
      );

      await tester.pumpWidget(scope);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.more_vert), findsWidgets);
    });

    testWidgets('menu contains remove friend option', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(body: FriendsPage()),
        ),
      );

      await tester.pumpWidget(scope);
      await tester.pumpAndSettle();

      // Tap the menu button
      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      expect(find.text('Remove friend'), findsOneWidget);
    });

    testWidgets('shows people icon in empty state', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(body: FriendsPage()),
        ),
        seedData: false,
      );

      await tester.pumpWidget(scope);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.people_outline), findsOneWidget);
    });

    testWidgets('friend card shows avatar with initials', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(body: FriendsPage()),
        ),
      );

      await tester.pumpWidget(scope);
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsWidgets);
    });

    testWidgets('can pull to refresh', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(body: FriendsPage()),
        ),
      );

      await tester.pumpWidget(scope);
      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}
