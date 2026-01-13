// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/ui/core/responsive/responsive.dart';
import 'package:timeshare/ui/features/calendar/widgets/calendar_widget.dart';
import 'package:timeshare/ui/features/calendar/widgets/event_list.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendars = ref.watch(calendarsProvider);
    final visibleEvents = ref.watch(visibleEventsProvider);

    return calendars.when(
      data: (_) => LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= Breakpoints.mobile;

          if (isWide) {
            // Tablet/Desktop: side-by-side layout
            return ConstrainedContent(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: min(400, constraints.maxWidth * 0.4),
                    child: CalendarWidget(eventsMap: visibleEvents.map),
                  ),
                  const VerticalDivider(),
                  Expanded(child: EventList(useExpanded: false)),
                ],
              ),
            );
          }

          // Mobile: vertical stack layout
          return Column(
            children: [
              CalendarWidget(eventsMap: visibleEvents.map),
              const Divider(),
              const EventList(),
            ],
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const SizedBox(),
    );
  }
}
