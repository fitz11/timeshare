import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:timeshare/util.dart';

class CalendarHelper {
  //Holds a list of events within a selected date or range
  late final ValueNotifier<List<Event>> selectedEvents;

  CalendarFormat calendarFormat;
  RangeSelectionMode rangeSelectionMode =
      RangeSelectionMode
          .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime focusedDay;
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;

  //boolean to set calendar to add event mode.
  bool addEventMode;

  CalendarHelper({
    this.calendarFormat = CalendarFormat.month,
    this.rangeSelectionMode = RangeSelectionMode.toggledOff,
    this.addEventMode = false,
  }) : focusedDay = DateTime.now();

  void initNotifier() {
    selectedDay = focusedDay;
    selectedEvents = ValueNotifier(getEventsForDay(selectedDay!));
  }

  Widget addEventModeButton() {
    if (addEventMode) {
      return Icon(Icons.search);
    } else {
      return Icon(Icons.add);
    }
  }

  List<Event> getEventsForDay(DateTime day) {
    // Implementation example
    return userEventList[day] ?? [];
  }

  List<Event> getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [for (final d in days) ...getEventsForDay(d)];
  }

  void onDaySelected(DateTime uselectedDay, DateTime ufocusedDay) {
    if (!isSameDay(selectedDay, uselectedDay)) {
      selectedDay = uselectedDay;
      focusedDay = ufocusedDay;
      rangeStart = null; // Important to clean those
      rangeEnd = null;
      rangeSelectionMode = RangeSelectionMode.toggledOff;

      selectedEvents.value = getEventsForDay(uselectedDay);
    }
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime ufocusedDay) {
    selectedDay = null;
    focusedDay = ufocusedDay;
    rangeStart = start;
    rangeEnd = end;
    rangeSelectionMode = RangeSelectionMode.toggledOn;
  }

  void onModePressed() {
    addEventMode = !addEventMode;
  }
}
