// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/ui/features/calendar/pages/calendar_admin_page.dart';
import 'package:timeshare/utils/error_utils.dart';

class CalendarFilterSheet extends ConsumerWidget {
  const CalendarFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCalendars = ref.watch(calendarsProvider);
    final selectedIds = ref.watch(selectedCalendarIdsProvider);
    final currentUserId = ref.watch(currentUserIdProvider);

    return allCalendars.when(
      data: (calendars) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select calendars',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (calendars.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'No calendars available',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...calendars.map((calendar) {
                final isSelected = selectedIds.contains(calendar.id);
                final isOwner = calendar.owner == currentUserId;
                return Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: Text(calendar.name),
                        subtitle: isOwner
                            ? Text(
                                'Owner',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              )
                            : null,
                        value: isSelected,
                        onChanged: (checked) {
                          ref
                              .read(selectedCalendarIdsProvider.notifier)
                              .toggle(calendar.id);
                        },
                      ),
                    ),
                    if (isOwner)
                      IconButton(
                        icon: const Icon(Icons.admin_panel_settings_outlined),
                        tooltip: 'Manage access',
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CalendarAdminPage(
                                calendarId: calendar.id,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              }),
            const SizedBox(height: 8),
          ],
        ),
      ),
      loading: () => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading calendars...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Failed to load calendars',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              formatError(error),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => ref.invalidate(calendarsProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
