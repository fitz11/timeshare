// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';

class DeleteEventDialog extends ConsumerWidget {
  const DeleteEventDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(visibleEventsProvider).list;
    return AlertDialog(
      title: Text('Select Event to delete'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadiusDirectional.circular(12),
              ),
              child: ListTile(
                title: Text(events[index].name),
                subtitle: Text(DateFormat.yMMMd().format(events[index].time)),
                trailing: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: events[index].color,
                    shape: events[index].shape,
                  ),
                ),
                onTap: () {
                  final event = events[index];
                  // Close dialog immediately (optimistic)
                  Navigator.pop(context);

                  if (event.calendarId != null) {
                    // Fire delete in background
                    ref
                        .read(calendarMutationsProvider.notifier)
                        .deleteEventOptimistic(
                          calendarId: event.calendarId!,
                          eventId: event.id,
                        )
                        .then((result) {
                      if (!context.mounted) return;
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
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
