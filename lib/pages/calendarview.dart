import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/event.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key, required this.calendars});
  final List<Calendar> calendars;

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  //used to build events viewing
  late final ValueNotifier<List<Event>> _selectedEvents;

  //TODO: add copy event functionality
  bool _copyEventMode = false;

  //BOILERPLATE DEFNINITIONS FOR THE CALENDAR WIDGET
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  //My added definitions;
  //loaded calendars are the ones that we will pull events from,
  //and events is the total list of events to display.
  //(maximum 4 per day)
  late final List<Calendar> _loadedCalendars;
  late final Map<DateTime, List<Event>> _events;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;

    //initially loads all calendars supplied to the widget
    _loadedCalendars = widget.calendars;

    //initially loads all events from all supplied calendars
    _events = _mapAllEvents(_getAllEventsInCalendars(_loadedCalendars));

    //loads the selected events; initially today
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  ///Essential function; loads events for each day
  List<Event> _getEventsForDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return _events[normalized] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return [for (final d in days) ..._getEventsForDay(d)];
  }

  ///background function: creates a list of all our active calendars
  List<Event> _getAllEventsInCalendars(List<Calendar> calendars) {
    return calendars.fold(
      [],
      (prev, list) =>
          prev.isEmpty ? list.getEvents() : prev += list.getEvents(),
    );
  }

  ///background function: creates a map of all events from a list
  /// Used for our calendarbuilder to create custom markers
  Map<DateTime, List<Event>> _mapAllEvents(List<Event> eventlist) {
    return eventlist.fold<Map<DateTime, List<Event>>>({}, (map, event) {
      final day = DateTime(event.time.year, event.time.month, event.time.day);
      map.putIfAbsent(day, () => []).add(event);
      return map;
    });
  }

  ///pretty ignorable function
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    }
  }

  ///pretty ignorable function
  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  //TODO: Where i left off
  void _openEventBuilder() async {
    Future<Calendar>? calendar = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("select Calendar to add event to:"),
        content: ListView.builder(
          itemCount: widget.calendars.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadiusDirectional.circular(12),
              ),
              child: ListTile(
                title: Text(widget.calendars[index].name),
                onTap: () {
                  setState((value) {
                    
                  });
                  return widget.calendars[index];
                },
              )
            );
          }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeshare'),
        elevation: 8,
        centerTitle: true,
        actions: [IconButton.outlined(onPressed: () {}, icon: Icon(Icons.add))],
      ),

      //the MEAT
      body: Column(
        children: [
          //names of active calendars;
          Center(
            child: Text(
              _loadedCalendars.fold(
                "",
                (prev, cal) => prev.isEmpty ? cal.name : '$prev, ${cal.name}',
              ),
            ),
          ),

          //The actual calendar viewing widget, which enables selection in
          //days or ranges.
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: firstDay,
            lastDay: lastDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(outsideDaysVisible: true),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
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
            calendarBuilders: CalendarBuilders<Event>(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return const SizedBox();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      events.take(4).map((event) {
                        return Container(
                          margin: const EdgeInsetsGeometry.symmetric(
                            horizontal: 0.5,
                          ),
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

          const SizedBox(height: 8.0),

          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
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
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text(value[index].title),
                      ),
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
