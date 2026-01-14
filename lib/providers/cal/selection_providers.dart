// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/cal/optimistic_providers.dart';

/// Selected calendar IDs - which calendars are visible.
/// Uses optimistic calendars for instant UI feedback.
class SelectedCalendarIds extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    // Use optimistic calendars for instant UI feedback
    final calendarsAsync = ref.watch(calendarsWithOptimisticProvider);
    final calendars = calendarsAsync.value ?? [];
    return calendars.map((c) => c.id).toSet();
  }

  void toggle(String id) {
    if (state.contains(id)) {
      state = state.where((e) => e != id).toSet();
    } else {
      state = {...state, id};
    }
  }

  void selectAll() {
    final calendars = ref.watch(calendarsWithOptimisticProvider).value ?? [];
    state = calendars.map((cal) => cal.id).toSet();
  }

  void clear() => state = {};
}

final selectedCalendarIdsProvider =
    NotifierProvider<SelectedCalendarIds, Set<String>>(
  SelectedCalendarIds.new,
);
