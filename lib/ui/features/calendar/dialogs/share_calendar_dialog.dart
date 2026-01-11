import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/data/models/user/app_user.dart';
import 'package:timeshare/utils/error_utils.dart';

void showShareCalendarDialog(
  BuildContext context,
  WidgetRef ref,
  AppUser friend,
) {
  final currentUserId = ref.read(currentUserIdProvider);
  if (currentUserId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please log in to share calendars.')),
    );
    return;
  }

  final calendarsAsync = ref.read(calendarsProvider);
  if (!calendarsAsync.hasValue) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calendars are still loading.')),
    );
    return;
  }
  final calendars =
      calendarsAsync.requireValue.where((cal) => cal.owner == currentUserId).toList();

  final Map<String, bool> sharedMap = {
    for (var cal in calendars) cal.id: cal.sharedWith.contains(friend.uid),
  };

  // Track which calendars are currently being updated
  final Set<String> updating = {};

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Share Calendars with ${friend.displayName}'),
            content: SizedBox(
              width: 300,
              height: 400,
              child: ListView(
                children: calendars.map((calendar) {
                  final isShared = sharedMap[calendar.id] ?? false;
                  final isUpdating = updating.contains(calendar.id);

                  return CheckboxListTile(
                    title: Text(calendar.name),
                    value: isShared,
                    enabled: !isUpdating,
                    secondary: isUpdating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                    onChanged: (value) async {
                      if (value == null || isUpdating) return;

                      final previousValue = sharedMap[calendar.id] ?? false;

                      // Optimistic update
                      setState(() {
                        sharedMap[calendar.id] = value;
                        updating.add(calendar.id);
                      });

                      try {
                        await ref
                            .read(calendarMutationsProvider.notifier)
                            .shareCalendar(calendar.id, friend.uid, value);
                      } catch (e) {
                        // Rollback on failure
                        setState(() {
                          sharedMap[calendar.id] = previousValue;
                        });

                        if (dialogContext.mounted) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(
                              content: Text('Failed to update: ${formatError(e)}'),
                              backgroundColor: Theme.of(dialogContext).colorScheme.error,
                            ),
                          );
                        }
                      } finally {
                        setState(() {
                          updating.remove(calendar.id);
                        });
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    },
  );
}
