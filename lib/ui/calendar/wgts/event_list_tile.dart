import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/event/event.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/data/providers/cal/cal_providers.dart';

class EventListItem extends ConsumerWidget {
  final Event event;
  const EventListItem({super.key, required this.event});

  void _onTap(BuildContext context, WidgetRef ref) {
    ref.read(copyModeNotifierProvider.notifier).on();
    ref.read(copyEventNotifierProvider.notifier).setCopyEvent(event);
    _showSnackBar(context);
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Copied '${event.name}' - tap date to paste."),
            Text('Select the Edit mode indicator to leave copy mode.'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Text(DateFormat.yMMMd().format(event.time)),
      title: Text(event.name),
      trailing: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: event.color, shape: event.shape),
      ),
      onTap: () => _onTap(context, ref),
    );
  }
}
