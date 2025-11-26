import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/enums.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';

class EventListItem extends ConsumerWidget {
  final Event event;
  const EventListItem({super.key, required this.event});

  void _onTap(BuildContext context, WidgetRef ref) {
    ref.read(interactionModeStateProvider.notifier).setCopy();
    ref.read(copyEventStateProvider.notifier).set(event);
    _showSnackBar(context);
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Copied '${event.name}' - tap a date on the calendar to paste.",
            ),
            const Text('Tap the calendar header to exit copy mode.'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendars = ref.watch(calendarsProvider);
    final copyMode = ref.watch(interactionModeStateProvider);
    final copiedEvent = ref.watch(copyEventStateProvider);

    // Check if this event is the one being copied (Freezed provides value equality)
    final isCopied =
        copyMode == InteractionMode.copy &&
        copiedEvent != null &&
        copiedEvent == event;

    // Find the calendar name for this event
    final calendarName = calendars.when(
      data: (calList) {
        try {
          final calendar = calList.firstWhere(
            (cal) => cal.id == event.calendarId,
          );
          return calendar.name;
        } catch (e) {
          return 'Unknown Calendar';
        }
      },
      loading: () => 'Loading...',
      error: (_, _) => 'Error',
    );

    return ListTile(
      leading: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: event.color, shape: event.shape),
      ),
      title: Text(event.name),
      subtitle: Text(calendarName),
      trailing: Text(DateFormat.yMMMd().format(event.time)),
      // Highlight with blue border/background when copied
      tileColor: isCopied ? Colors.blue.withValues(alpha: 0.1) : null,
      shape: isCopied
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.blue, width: 2),
            )
          : null,
      onTap: () => _onTap(context, ref),
    );
  }
}
