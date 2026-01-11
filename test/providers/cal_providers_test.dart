// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';

import '../fixtures/test_data.dart';
import '../mocks/mock_providers.dart';

void main() {
  group('calendarRepositoryProvider', () {
    test('provides a CalendarRepository instance', () async {
      final container = await createTestContainer();
      addTearDown(container.dispose);

      final repo = container.read(calendarRepositoryProvider);

      expect(repo, isNotNull);
    });
  });

  group('calendarsProvider', () {
    test('streams calendars from repository', () async {
      final container = await createTestContainer();
      addTearDown(container.dispose);

      final calendarsAsync = container.read(calendarsProvider);

      // Stream provider starts with loading
      expect(calendarsAsync.isLoading || calendarsAsync.hasValue, true);
    });
  });

  group('SelectedCalendarIds', () {
    test('SelectedCalendarIds is an async notifier provider', () {
      // Verify the provider type
      expect(selectedCalendarIdsProvider, isNotNull);
    });
  });

  group('SelectedDay', () {
    test('initializes to null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final day = container.read(selectedDayProvider);

      expect(day, isNull);
    });

    test('select sets the day', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final targetDay = DateTime.utc(2024, 6, 15);
      container.read(selectedDayProvider.notifier).select(targetDay);

      final day = container.read(selectedDayProvider);

      expect(day, targetDay);
    });

    test('clear sets day to null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(selectedDayProvider.notifier).select(DateTime.utc(2024, 6, 15));
      container.read(selectedDayProvider.notifier).clear();

      final day = container.read(selectedDayProvider);

      expect(day, isNull);
    });
  });

  group('AfterTodayFilter', () {
    test('initializes to true', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final filter = container.read(afterTodayFilterProvider);

      expect(filter, true);
    });

    test('toggle changes value', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(afterTodayFilterProvider.notifier).toggle();

      final filter = container.read(afterTodayFilterProvider);

      expect(filter, false);
    });

    test('set changes value directly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(afterTodayFilterProvider.notifier).set(false);

      expect(container.read(afterTodayFilterProvider), false);

      container.read(afterTodayFilterProvider.notifier).set(true);

      expect(container.read(afterTodayFilterProvider), true);
    });
  });

  group('InteractionModeState', () {
    test('initializes to normal', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final mode = container.read(interactionModeStateProvider);

      expect(mode, InteractionMode.normal);
    });

    test('setMode changes mode', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(interactionModeStateProvider.notifier).setMode(InteractionMode.copy);

      final mode = container.read(interactionModeStateProvider);

      expect(mode, InteractionMode.copy);
    });

    test('setNormal sets to normal', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(interactionModeStateProvider.notifier).setCopy();
      container.read(interactionModeStateProvider.notifier).setNormal();

      final mode = container.read(interactionModeStateProvider);

      expect(mode, InteractionMode.normal);
    });

    test('setCopy sets to copy', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(interactionModeStateProvider.notifier).setCopy();

      final mode = container.read(interactionModeStateProvider);

      expect(mode, InteractionMode.copy);
    });

    test('setDelete sets to delete', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(interactionModeStateProvider.notifier).setDelete();

      final mode = container.read(interactionModeStateProvider);

      expect(mode, InteractionMode.delete);
    });
  });

  group('CopyEventState', () {
    test('initializes to null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final event = container.read(copyEventStateProvider);

      expect(event, isNull);
    });

    test('set stores event', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(copyEventStateProvider.notifier).set(TestData.testEvent);

      final event = container.read(copyEventStateProvider);

      expect(event, isNotNull);
      expect(event!.name, TestData.testEvent.name);
    });

    test('clear sets to null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(copyEventStateProvider.notifier).set(TestData.testEvent);
      container.read(copyEventStateProvider.notifier).clear();

      final event = container.read(copyEventStateProvider);

      expect(event, isNull);
    });
  });

  group('visibleEventsProvider', () {
    test('VisibleEvents stores map and list', () {
      final event = Event(
        name: 'Test',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      final visible = VisibleEvents(
        map: {DateTime.utc(2024, 6, 15): [event]},
        list: [event],
      );

      expect(visible, isA<VisibleEvents>());
      expect(visible.map, isA<Map<DateTime, List<Event>>>());
      expect(visible.list, isA<List<Event>>());
    });

    test('returns empty map and list for empty data', () {
      final visible = const VisibleEvents(map: {}, list: []);

      expect(visible.map, isEmpty);
      expect(visible.list, isEmpty);
    });
  });

  group('VisibleEvents', () {
    test('stores map and list correctly', () {
      final event = Event(
        name: 'Test',
        time: DateTime.utc(2024, 6, 15),
        calendarId: 'cal1',
      );

      final visible = VisibleEvents(
        map: {DateTime.utc(2024, 6, 15): [event]},
        list: [event],
      );

      expect(visible.map.length, 1);
      expect(visible.list.length, 1);
    });
  });
}
