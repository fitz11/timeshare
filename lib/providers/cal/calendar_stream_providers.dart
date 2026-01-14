// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/providers/cal/repository_providers.dart';

/// Main calendar stream - automatically updates when data changes.
/// Keep alive to prevent re-initialization when navigating away.
final calendarsProvider = StreamProvider<List<Calendar>>((ref) {
  ref.keepAlive();
  final repo = ref.watch(calendarRepositoryProvider);
  return repo.watchAllAvailableCalendars();
});
