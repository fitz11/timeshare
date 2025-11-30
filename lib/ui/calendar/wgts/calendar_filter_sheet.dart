// Timeshare: a cross-platform app to make and share calendars.
// Copyright (C) 2025  David Fitzsimmons
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
              final isSelected = selectedIds.value?.contains(calendar.id);
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
