// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';

class CalendarFilterSheet extends ConsumerWidget {
  const CalendarFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCalendars = ref.watch(calendarsProvider);
    final selectedIds = ref.watch(selectedCalendarIdsProvider);

    return allCalendars.when(
      data: (calendars) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // makes it a modal "sheet"
          children: [
            const Text(
              'Select calendars',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...calendars.map((calendar) {
              final isSelected = selectedIds.contains(calendar.id);
              return CheckboxListTile(
                title: Text(calendar.name),
                value: isSelected,
                onChanged: (checked) {
                  ref
                      .read(selectedCalendarIdsProvider.notifier)
                      .toggle(calendar.id);
                },
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
      loading: () => SizedBox(),
      error: (_, _) => SizedBox(),
    );
  }
}
