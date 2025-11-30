// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/ui/calendar/wgts/calendar_widget.dart';
import 'package:timeshare/ui/calendar/wgts/event_list.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendars = ref.watch(calendarsProvider);
    final visibleEvents = ref.watch(visibleEventsProvider);
    ref.watch(interactionModeStateProvider);
    ref.watch(copyEventStateProvider);
    return calendars.when(
      data: (_) => Column(
        children: [
          CalendarWidget(eventsMap: visibleEvents.map),

          const Divider(),

          EventList(),
        ],
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (_, _) => SizedBox(),
    );
  }
}
