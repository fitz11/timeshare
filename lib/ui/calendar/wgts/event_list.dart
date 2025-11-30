// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

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
