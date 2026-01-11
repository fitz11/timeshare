import 'package:flutter/material.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/ui/features/calendar/dialogs/create_event_dialog.dart';

void openEventBuilder(BuildContext context, List<Calendar> calendars) async {
  // First, show dialog to select calendar
  Calendar? calendar = await showDialog<Calendar>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Select Calendar'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: calendars.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text(calendars[index].name),
                onTap: () {
                  Navigator.pop(context, calendars[index]);
                },
              ),
            );
          },
        ),
      ),
    ),
  );

  // If calendar was selected, show the create event dialog
  if (calendar != null && context.mounted) {
    showDialog(
      context: context,
      builder: (context) => CreateEventDialog(
        calendarId: calendar.id,
        calendarName: calendar.name,
      ),
    );
  }
}
