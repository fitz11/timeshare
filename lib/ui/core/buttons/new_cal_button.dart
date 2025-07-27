import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/ui/widgets/create_calendar_dialog.dart';

class NewCalButton extends ConsumerWidget {
  const NewCalButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
      onPressed: () {
        showCreateCalendarDialog(context, ref);
      },
      child: Row(children: [Icon(Icons.calendar_month), Text('New Calendar')]),
    );
  }
}
