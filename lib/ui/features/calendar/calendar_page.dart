// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/services/logging/app_logger.dart';
import 'package:timeshare/ui/core/responsive/responsive.dart';
import 'package:timeshare/ui/features/calendar/widgets/calendar_widget.dart';
import 'package:timeshare/ui/features/calendar/widgets/event_list.dart';

final _logger = AppLogger();
const _tag = 'CalendarPage';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendars = ref.watch(calendarsProvider);
    // Use full events map for calendar markers (not filtered by selection)
    final allEventsMap = ref.watch(expandedEventsMapProvider);

    return calendars.when(
      data: (_) {
        return LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= Breakpoints.mobile;

          if (isWide) {
            // Tablet/Desktop: side-by-side layout
            const dividerWidth = 16.0; // VerticalDivider default width
            final contentWidth = min(1200.0, constraints.maxWidth);
            final calendarWidth = min(400.0, contentWidth * 0.4);
            final eventListWidth = contentWidth - calendarWidth - dividerWidth;
            // Guard against infinite height (can happen on web)
            final availableHeight = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : MediaQuery.of(context).size.height;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: calendarWidth,
                  height: availableHeight,
                  child: SingleChildScrollView(
                    child: CalendarWidget(eventsMap: allEventsMap),
                  ),
                ),
                const VerticalDivider(width: dividerWidth),
                SizedBox(
                  width: eventListWidth,
                  height: availableHeight,
                  child: EventList(useExpanded: false),
                ),
              ],
            );
          }

          // Mobile: vertical stack layout
          return Column(
            children: [
              CalendarWidget(eventsMap: allEventsMap),
              const Divider(),
              const EventList(),
            ],
          );
        },
      );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stack) {
        _logger.error('Failed to load calendars', error: error, stackTrace: stack, tag: _tag);
        return const SizedBox();
      },
    );
  }
}
