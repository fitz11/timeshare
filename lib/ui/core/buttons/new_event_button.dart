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
