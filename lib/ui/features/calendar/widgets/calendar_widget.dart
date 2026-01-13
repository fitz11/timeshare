// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/data/enums.dart';

DateTime today = normalizeDate(DateTime.now());
DateTime start = today.subtract(const Duration(days: 365));
DateTime end = today.add(const Duration(days: 365));

class CalendarWidget extends ConsumerWidget {
  final Map<DateTime, List<Event>> eventsMap;
  const CalendarWidget({super.key, required this.eventsMap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final focusedDay = ref.watch(focusedDayProvider);
    final calendarFormat = ref.watch(calendarFormatStateProvider);
    final copyMode = ref.watch(interactionModeStateProvider);

    // Use theme colors instead of hardcoded Colors.blue
    final copyModeColor = Theme.of(context).colorScheme.primary;

    final headerStyle = copyMode == InteractionMode.copy
        ? HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: copyModeColor,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: copyModeColor),
            rightChevronIcon: Icon(Icons.chevron_right, color: copyModeColor),
          )
        : const HeaderStyle(titleCentered: true, formatButtonVisible: false);

    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: start,
      lastDay: end,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      calendarFormat: calendarFormat,
      headerStyle: headerStyle,
      sixWeekMonthsEnforced: true,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: const CalendarStyle(outsideDaysVisible: true),
      onDaySelected: (selectedDay, newFocusedDay) =>
          _onDaySelected(ref, selectedDay, newFocusedDay),
      eventLoader: (day) => eventsMap[normalizeDate(day)] ?? [],
      onHeaderTapped: (day) {
        ref.read(copyEventStateProvider.notifier).clear();
        if (ref.read(interactionModeStateProvider) == InteractionMode.normal) {
          ref.read(selectedDayProvider.notifier).clear();
        }
        ref.read(interactionModeStateProvider.notifier).setNormal();
      },
      onFormatChanged: (format) {
        ref.read(calendarFormatStateProvider.notifier).set(format);
      },
      onPageChanged: (newFocusedDay) {
        ref.read(focusedDayProvider.notifier).set(newFocusedDay);
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return const SizedBox();
          final typedEvents = events.cast<Event>();

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: typedEvents.take(4).map((event) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 0.5),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: event.color,
                  shape: event.shape,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _onDaySelected(WidgetRef ref, DateTime selectedDay, DateTime focusedDay) {
    ref.read(focusedDayProvider.notifier).set(focusedDay);
    ref.read(selectedDayProvider.notifier).select(selectedDay);

    // Handle copy mode
    final mode = ref.read(interactionModeStateProvider);
    final copiedEvent = ref.read(copyEventStateProvider);
    if (mode == InteractionMode.copy && copiedEvent != null) {
      _copyEvent(ref, selectedDay, copiedEvent);
    }
  }

  void _copyEvent(WidgetRef ref, DateTime targetDate, Event sourceEvent) {
    final copied = sourceEvent.copyWith(time: targetDate);
    if (copied.calendarId != null) {
      ref
          .read(calendarMutationsProvider.notifier)
          .addEvent(calendarId: copied.calendarId!, event: copied);
    }
    ref.read(copyEventStateProvider.notifier).set(copied);
  }
}
