import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/ui/dialogs/delete_event_dialog.dart';

class DeleteButton extends ConsumerWidget {
  const DeleteButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleEvents = ref.watch(visibleEventsProvider);
    final hasEvents = visibleEvents.list.isNotEmpty;

    return ListTile(
      leading: Icon(
        Icons.delete_outline,
        color: hasEvents
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
      ),
      title: const Text('Delete Event'),
      subtitle: Text(
        hasEvents
            ? 'Remove an event from your calendar'
            : 'No events available to delete',
      ),
      enabled: hasEvents,
      onTap: hasEvents
          ? () {
              showDialog(
                context: context,
                builder: (context) => DeleteEventDialog(),
              );
              Navigator.pop(context);
            }
          : null,
    );
  }
}
