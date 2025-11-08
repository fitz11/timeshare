import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/ui/dialogs/create_calendar_dialog.dart';

class NewCalButton extends ConsumerWidget {
  const NewCalButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(Icons.calendar_month),
      title: const Text('New Calendar'),
      subtitle: const Text('Create a new calendar'),
      onTap: () {
        Navigator.pop(context); // Close drawer
        showCreateCalendarDialog(context, ref);
      },
    );
  }
}
