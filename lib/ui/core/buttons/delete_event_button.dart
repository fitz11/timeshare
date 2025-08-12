import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/providers/cal/cal_providers.dart';
import 'package:timeshare/ui/dialogs/delete_event_dialog.dart';

class DeleteButton extends ConsumerWidget {
  const DeleteButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(visibleEventsListProvider);
    return FilledButton(
      onPressed: () {
        showDeleteDialog(context, ref, events);
      },
      child: Row(children: [Icon(Icons.delete), Text('Delete Event')]),
    );
  }
}
