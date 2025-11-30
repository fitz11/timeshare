// Timeshare: a cross-platform app to make and share calendars.
// Copyright (C) 2025  David Fitzsimmons
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/ui/dialogs/create_event_dialog.dart';

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
