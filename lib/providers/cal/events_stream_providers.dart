// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/providers/cal/repository_providers.dart';
import 'package:timeshare/providers/cal/selection_providers.dart';

/// Events stream for selected calendars.
/// Keep alive to prevent re-initialization when navigating away.
final eventsForSelectedCalendarsProvider = StreamProvider<List<Event>>((ref) {
  ref.keepAlive();
  final repo = ref.watch(calendarRepositoryProvider);
  final selectedIds = ref.watch(selectedCalendarIdsProvider);

  if (selectedIds.isEmpty) {
    return Stream.value([]);
  }

  return repo.watchEventsForCalendars(selectedIds.toList());
});
