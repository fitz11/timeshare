// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/providers/cal/events_providers.dart';
import 'package:timeshare/providers/cal/optimistic_providers.dart';

/// Calendar name lookup by ID - prevents full calendar list watches in EventListItem.
/// Uses family modifier so each calendar ID gets its own cached provider instance.
final calendarNameProvider = Provider.family<String, String>((ref, calendarId) {
  final calendars = ref.watch(calendarsWithOptimisticProvider).value ?? [];
  try {
    return calendars.firstWhere((c) => c.id == calendarId).name;
  } catch (_) {
    return 'Unknown Calendar';
  }
});

/// Map of calendar IDs to names - for efficient bulk lookups in lists.
final calendarNamesMapProvider = Provider<Map<String, String>>((ref) {
  final calendars = ref.watch(calendarsWithOptimisticProvider).value ?? [];
  return {for (final c in calendars) c.id: c.name};
});

/// Look up source event by ID (non-expanded, original recurrence start time).
/// Used by EditEventDialog to get the true source event rather than an expanded occurrence.
final sourceEventProvider = Provider.family<Event?, String>((ref, eventId) {
  final events = ref.watch(eventsWithOptimisticProvider).value ?? [];
  try {
    return events.firstWhere((e) => e.id == eventId);
  } catch (_) {
    return null;
  }
});
