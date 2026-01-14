// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/ui/features/calendar/pages/calendar_admin_page.dart';
import 'package:timeshare/utils/error_utils.dart';

class CalendarFilterDialog extends ConsumerWidget {
  const CalendarFilterDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use optimistic calendars for instant UI feedback
    final allCalendars = ref.watch(calendarsWithOptimisticProvider);
    final selectedIds = ref.watch(selectedCalendarIdsProvider);
    final currentUserId = ref.watch(currentUserIdProvider);

    return AlertDialog(
      title: const Text('Select calendars'),
      content: allCalendars.when(
        data: (calendars) {
          if (calendars.isEmpty) {
            return Text(
              'No calendars available',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            );
          }
          return SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: calendars.length,
              itemBuilder: (context, index) {
                final calendar = calendars[index];
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
              },
            ),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => Column(
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
