import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/event/event.dart';
import 'package:timeshare/data/providers/cal/cal_providers.dart';

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
  //BOILERPLATE DEFNINITIONS FOR THE CALENDAR WIDGET
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = today;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
  }

  // when a calendar day is selected;
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      _selectedDay = selectedDay;
    });
    bool copyMode = ref.read(copyModeNotifierProvider);
    Event? copied = ref.read(copyEventNotifierProvider);
    if (copyMode && copied != null) _copyEvent();
  }

  void _copyEvent() {
    final copied = ref
        .read(copyEventNotifierProvider)!
        .copyWith(time: _selectedDay!);
    ref
        .read(calendarNotifierProvider.notifier)
        .addEventToCalendar(calendarId: copied.calendarId, event: copied);
  }

  @override
  Widget build(BuildContext context) {
    final eventsMap = ref.watch(visibleEventsMapProvider);
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: start,
      lastDay: end,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: CalendarFormat.month,
      sixWeekMonthsEnforced: true,
      rangeSelectionMode: RangeSelectionMode.disabled,
      eventLoader: (day) {
        return eventsMap[normalizeDate(day)] ?? [];
      },
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: const CalendarStyle(outsideDaysVisible: true),
      onDaySelected: _onDaySelected,
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },

      //this part defines the custom markers based on events.
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return const SizedBox();
          final typedEvents = events.cast<Event>();

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                typedEvents.take(4).map((event) {
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
