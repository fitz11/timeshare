import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/event.dart';
import 'package:timeshare/pages/calendarhepler.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  //Helper class to clean up some overhead in the UI code
  final CalendarHelper _cHelper = CalendarHelper();

  @override
  void initState() {
    super.initState();
    _cHelper.initNotifier();
  }

  @override
  void dispose() {
    _cHelper.selectedEvents.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_cHelper.selectedDay, selectedDay)) {
      setState(() {
        _cHelper.selectedDay = selectedDay;
        _cHelper.focusedDay = focusedDay;
        _cHelper.rangeStart = null; // Important to clean those
        _cHelper.rangeEnd = null;
        _cHelper.rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _cHelper.selectedEvents.value = _cHelper.getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _cHelper.selectedDay = null;
      _cHelper.focusedDay = focusedDay;
      _cHelper.rangeStart = start;
      _cHelper.rangeEnd = end;
      _cHelper.rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _cHelper.selectedEvents.value = _cHelper.getEventsForRange(start, end);
    } else if (start != null) {
      _cHelper.selectedEvents.value = _cHelper.getEventsForDay(start);
    } else if (end != null) {
      _cHelper.selectedEvents.value = _cHelper.getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeshare'),
        elevation: 5,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _cHelper.onModePressed();
              });
            },
            icon: _cHelper.addEventModeButton(),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: _cHelper.focusedDay,
            selectedDayPredicate: (day) => isSameDay(_cHelper.selectedDay, day),
            rangeStartDay: _cHelper.rangeStart,
            rangeEndDay: _cHelper.rangeEnd,
            calendarFormat: _cHelper.calendarFormat,
            rangeSelectionMode: _cHelper.rangeSelectionMode,
            eventLoader: _cHelper.getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
              markerDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.rectangle,
              ),
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_cHelper.calendarFormat != format) {
                setState(() {
                  _cHelper.calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _cHelper.focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 16.0),
          Center(
            child:
                _cHelper.addEventMode
                    ? Text('Events available to add')
                    : Text('Viewing events in selection'),
          ),
          Expanded(
            child:
                _cHelper.addEventMode
                    ? ListView.builder(
                      itemCount: userEvents.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            title: Text('${userEvents[index]}'),
                            onTap: () {
                              if (_cHelper.selectedDay != null) {
                                setState(() {
                                  userEventList.putIfAbsent(
                                    _cHelper.selectedDay!,
                                    () => [],
                                  );
                                  userEventList[_cHelper.selectedDay]!.add(
                                    userEvents[index],
                                  );
                                });
                              } else if (_cHelper.rangeStart != null &&
                                  _cHelper.rangeEnd != null) {
                                setState(() {
                                  for (
                                    DateTime date = _cHelper.rangeStart!;
                                    !date.isAfter(_cHelper.rangeEnd!);
                                    date = date.add(Duration(days: 1))
                                  ) {
                                    userEventList.putIfAbsent(date, () => []);
                                    userEventList[date]!.add(userEvents[index]);
                                  }
                                });
                              }
                            },
                          ),
                        );
                      },
                    )
                    : ValueListenableBuilder<List<Event>>(
                      valueListenable: _cHelper.selectedEvents,
                      builder: (context, value, _) {
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(title: Text('${value[index]}')),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
