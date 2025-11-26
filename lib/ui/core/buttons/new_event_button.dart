import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/ui/dialogs/open_eventbuilder_dialog.dart';

class NewEventButton extends ConsumerWidget {
  const NewEventButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCalendars = ref.watch(calendarsProvider);
    return allCalendars.when(
      data: (calendars) => ListTile(
        leading: const Icon(Icons.event),
        title: const Text('New Event'),
        subtitle: const Text('Add an event to a calendar'),
        onTap: () {
          Navigator.pop(context); // Close drawer
          openEventBuilder(context, calendars);
        },
      ),
      loading: () => const ListTile(
        leading: CircularProgressIndicator(),
        title: Text('New Event'),
        enabled: false,
      ),
      error: (error, stackTrace) => const ListTile(
        leading: Icon(Icons.error_outline),
        title: Text('New Event'),
        subtitle: Text('Unable to load calendars'),
        enabled: false,
      ),
    );
  }
}
