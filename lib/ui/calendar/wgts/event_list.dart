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
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/ui/calendar/wgts/event_list_item.dart';

class EventList extends ConsumerWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsList = ref.watch(visibleEventsProvider).list;
    final copyMode = ref.watch(interactionModeStateProvider);
    return Expanded(
      child: ListView.builder(
        itemCount: eventsList.length,
        itemBuilder: (context, index) {
          return copyMode == InteractionMode.normal
              ? Dismissible(
                  key: ValueKey(eventsList[index]),
                  direction: DismissDirection.endToStart,
                  background: Container(color: Colors.red),
                  onDismissed: (_) {
                    ref
                        .read(calendarMutationsProvider.notifier)
                        .removeEvent(
                          calendarId: eventsList[index].calendarId,
                          event: eventsList[index],
                        );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: EventListItem(event: eventsList[index]),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: EventListItem(event: eventsList[index]),
                );
        },
      ),
    );
  }
}
