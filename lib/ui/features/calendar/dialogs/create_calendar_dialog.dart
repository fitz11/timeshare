// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';

void showCreateCalendarDialog(BuildContext context, WidgetRef ref) {
  final nameController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Create New Calendar'),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(labelText: 'Calendar Name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isEmpty) return;

            final uid = ref.read(currentUserIdProvider);
            if (uid == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please log in to create calendars.'),
                    duration: Duration(seconds: 5),
                  ),
              );
              return;
            }

            // Close dialog immediately (optimistic)
            Navigator.pop(context);

            // Fire mutation in background
            ref
                .read(calendarMutationsProvider.notifier)
                .addCalendarOptimistic(ownerUid: uid, name: name)
                .then((result) {
              if (result.isFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result.error!),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            });
          },
          child: const Text('Create'),
        ),
      ],
    ),
  );
}
