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
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';

class DeleteEventDialog extends ConsumerWidget {
  const DeleteEventDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(visibleEventsProvider).list;
    return AlertDialog(
      title: Text('Select Event to delete'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadiusDirectional.circular(12),
              ),
              child: ListTile(
                title: Text(events[index].name),
                subtitle: Text(DateFormat.yMMMd().format(events[index].time)),
                trailing: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: events[index].color,
                    shape: events[index].shape,
                  ),
                ),
                onTap: () {
                  ref
                      .read(calendarMutationsProvider.notifier)
                      .removeEvent(
                        calendarId: events[index].calendarId,
                        event: events[index],
                      );
                  Navigator.pop(context);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
