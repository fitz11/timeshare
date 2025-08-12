import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/providers/cal/cal_providers.dart';
import 'package:timeshare/ui/dialogs/open_eventbuilder_dialog.dart';

class NewEventButton extends ConsumerWidget {
  const NewEventButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCalendars = ref.watch(calendarNotifierProvider);
    return FilledButton.tonal(
      onPressed: () {
        openEventBuilder(context, allCalendars.requireValue);
      },
      child: Row(children: [Icon(Icons.calendar_today), Text('New Event')]),
    );
  }
}
