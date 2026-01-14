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
    final copiedEvent = ref.watch(copyEventStateProvider);

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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cancel chip when in copy mode
        if (copyMode == InteractionMode.copy && copiedEvent != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ActionChip(
              avatar: const Icon(Icons.copy, size: 18),
              label: Text(
                'Copying "${copiedEvent.name}" - Tap to cancel',
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                ref.read(copyEventStateProvider.notifier).clear();
                ref.read(interactionModeStateProvider.notifier).setNormal();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        TableCalendar(
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
          _onDaySelected(context, ref, selectedDay, newFocusedDay),
      eventLoader: (day) => eventsMap[normalizeDate(day)] ?? [],
      onHeaderTapped: (day) {
        final wasInCopyMode = ref.read(interactionModeStateProvider) == InteractionMode.copy;
        ref.read(copyEventStateProvider.notifier).clear();
        if (ref.read(interactionModeStateProvider) == InteractionMode.normal) {
          ref.read(selectedDayProvider.notifier).clear();
        }
        ref.read(interactionModeStateProvider.notifier).setNormal();
        if (wasInCopyMode) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
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
    ),
      ],
    );
  }

  void _onDaySelected(BuildContext context, WidgetRef ref, DateTime selectedDay, DateTime focusedDay) {
    ref.read(focusedDayProvider.notifier).set(focusedDay);
    ref.read(selectedDayProvider.notifier).select(selectedDay);

    // Handle copy mode
    final mode = ref.read(interactionModeStateProvider);
    final copiedEvent = ref.read(copyEventStateProvider);
    if (mode == InteractionMode.copy && copiedEvent != null) {
      _copyEvent(context, ref, selectedDay, copiedEvent);
    }
  }

  void _copyEvent(BuildContext context, WidgetRef ref, DateTime targetDate, Event sourceEvent) {
    // Preserve source event's time when copying to a new date
    final targetDateTime = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      sourceEvent.time.hour,
      sourceEvent.time.minute,
    );
    final copied = sourceEvent.copyWith(
      id: '', // New ID will be generated
      time: targetDateTime,
    );
    if (copied.calendarId != null) {
      // Use optimistic mutation for instant feedback
      ref
          .read(calendarMutationsProvider.notifier)
          .addEventOptimistic(calendarId: copied.calendarId!, event: copied)
          .then((result) {
        if (!context.mounted) return;
        if (result.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.error!),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      });
    }
    // Keep the source event selected for additional copies
    ref.read(copyEventStateProvider.notifier).set(sourceEvent);
  }
}
