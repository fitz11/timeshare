import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/providers/cal/cal_providers.dart';
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
              color: Colors.blue,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.blue),
          )
        : HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
          );

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

      onHeaderTapped: (day) =>
          ref.read(copyEventStateProvider.notifier).clear(),

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
