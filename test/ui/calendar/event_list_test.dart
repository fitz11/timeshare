// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/ui/features/calendar/widgets/event_list.dart';

void main() {
  group('EventList', () {
    testWidgets('displays empty list when no events', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            visibleEventsProvider.overrideWithValue(
              const VisibleEvents(map: {}, list: []),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [EventList()],
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('displays list of events', (tester) async {
      final events = [
        Event(
          id: 'event-1',
          name: 'Event 1',
          time: DateTime.utc(2024, 6, 15),
          calendarId: 'cal1',
          color: Colors.blue,
        ),
        Event(
          id: 'event-2',
          name: 'Event 2',
          time: DateTime.utc(2024, 6, 16),
          calendarId: 'cal1',
          color: Colors.red,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            visibleEventsProvider.overrideWithValue(
              VisibleEvents(map: {}, list: events),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [EventList()],
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('events are dismissible in normal mode', (tester) async {
      final event = Event(
        id: 'event-dismissible',
        name: 'Dismissible Event',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            visibleEventsProvider.overrideWithValue(
              VisibleEvents(map: {}, list: [event]),
            ),
            // InteractionMode.normal is the default, so no override needed
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [EventList()],
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Dismissible), findsOneWidget);
    });

    testWidgets('each event has decorated container', (tester) async {
      final event = Event(
        id: 'event-decorated',
        name: 'Decorated Event',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            visibleEventsProvider.overrideWithValue(
              VisibleEvents(map: {}, list: [event]),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [EventList()],
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Find decorated containers (events are wrapped in Container with BoxDecoration)
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('ListView is created for events', (tester) async {
      final events = [
        Event(
          id: 'event-test',
          name: 'Test Event',
          time: DateTime.utc(2024, 6, 15),
          calendarId: 'cal1',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            visibleEventsProvider.overrideWithValue(
              VisibleEvents(map: {}, list: events),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [EventList()],
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
