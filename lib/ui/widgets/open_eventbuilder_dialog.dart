import 'package:flutter/material.dart';
import 'package:timeshare/data/calendar/calendar.dart';
import 'package:timeshare/ui/pages/eventspage.dart';

void openEventBuilder(BuildContext context, List<Calendar> calendars) async {
  Calendar? calendar = await showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text("select Calendar to add event to:"),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView.builder(
              itemCount: calendars.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadiusDirectional.circular(12),
                  ),
                  child: ListTile(
                    title: Text(calendars[index].name),
                    onTap: () {
                      Navigator.pop(context, calendars[index]);
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
  );
  if (calendar == null) return;
  Navigator.push(
    // ignore: use_build_context_synchronously
    context,
    MaterialPageRoute(
      builder:
          (context) =>
              EventsPage(title: calendar.name, calendarId: calendar.id),
    ),
  );
}
