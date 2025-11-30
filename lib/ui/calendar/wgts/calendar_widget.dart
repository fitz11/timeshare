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
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/data/enums.dart';

DateTime today = normalizeDate(DateTime.now());
DateTime start = today.subtract(const Duration(days: 365));
DateTime end = today.add(const Duration(days: 365));

class CalendarWidget extends ConsumerStatefulWidget {
  final Map<DateTime, List<Event>> eventsMap;
  const CalendarWidget({super.key, required this.eventsMap});

  @override
  ConsumerState<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends ConsumerState<CalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = today;

  // when a calendar day is selected;
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });

    // Update selected day in provider (single source of truth)
    ref.read(selectedDayProvider.notifier).select(selectedDay);

    // Handle copy mode
    final mode = ref.read(interactionModeStateProvider);
    final copiedEvent = ref.read(copyEventStateProvider);
    if (mode == InteractionMode.copy && copiedEvent != null) {
      _copyEvent(selectedDay, copiedEvent);
    }
  }

  void _copyEvent(DateTime targetDate, Event sourceEvent) {
    final copied = sourceEvent.copyWith(time: targetDate);
    ref
        .read(calendarMutationsProvider.notifier)
        .addEventToCalendar(calendarId: copied.calendarId, event: copied);
    ref.read(copyEventStateProvider.notifier).set(copied);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = ref.watch(selectedDayProvider);
    final copyMode = ref.watch(interactionModeStateProvider);

    // Change header color to blue when in copy mode, and black in normal
    final headerStyle = copyMode == InteractionMode.copy
        ? HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.blue),
          )
        : HeaderStyle(titleCentered: true, formatButtonVisible: false);

    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: start,
      lastDay: end,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      calendarFormat: CalendarFormat.month,
      headerStyle: headerStyle,
      sixWeekMonthsEnforced: true,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: const CalendarStyle(outsideDaysVisible: true),
      onDaySelected: _onDaySelected,

      eventLoader: (day) => widget.eventsMap[normalizeDate(day)] ?? [],

      onHeaderTapped: (day) {
        ref.read(copyEventStateProvider.notifier).clear();
        if (ref.read(interactionModeStateProvider) == InteractionMode.normal) {
          ref.read(selectedDayProvider.notifier).clear();
        }
        ref.read(interactionModeStateProvider.notifier).setNormal();
      },

      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },

      //this part defines the custom markers based on events.
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
}
