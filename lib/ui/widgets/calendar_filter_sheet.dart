import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers.dart';

class CalendarFilterSheet extends ConsumerWidget {
  const CalendarFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCalendars = ref.watch(calendarNotifierProvider);
    final selectedIds = ref.watch(selectedCalendarsProvider); // Set<String>

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // makes it a modal "sheet"
        children: [
          const Text(
            "Select calendars",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...allCalendars.map((calendar) {
            final isSelected = selectedIds.contains(calendar.id);
            return CheckboxListTile(
              title: Text(calendar.name),
              value: isSelected,
              onChanged: (checked) {
                final notifier = ref.read(selectedCalendarsProvider.notifier);
                if (checked == true) {
                  notifier.add(calendar.id);
                } else {
                  notifier.remove(calendar.id);
                }
              },
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
