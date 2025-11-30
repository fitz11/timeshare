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
import 'package:timeshare/ui/dialogs/delete_event_dialog.dart';

class DeleteButton extends ConsumerWidget {
  const DeleteButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleEvents = ref.watch(visibleEventsProvider);
    final hasEvents = visibleEvents.list.isNotEmpty;

    return ListTile(
      leading: Icon(
        Icons.delete_outline,
        color: hasEvents
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
      ),
      title: const Text('Delete Event'),
      subtitle: Text(
        hasEvents
            ? 'Remove an event from your calendar'
            : 'No events available to delete',
      ),
      enabled: hasEvents,
      onTap: hasEvents
          ? () {
              showDialog(
                context: context,
                builder: (context) => DeleteEventDialog(),
              );
              Navigator.pop(context);
            }
          : null,
    );
  }
}
