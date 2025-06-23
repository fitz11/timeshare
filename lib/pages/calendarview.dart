import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/classes/calendar/calendar.dart';
import 'package:timeshare/classes/event/event.dart';
import 'package:timeshare/util.dart';
import 'package:timeshare/pages/eventspage.dart';

//it is a dependency, don't let dartls lie to you
import 'package:intl/intl.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key, required this.calendars});
  final List<Calendar> calendars;

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  //BOILERPLATE DEFNINITIONS FOR THE CALENDAR WIDGET
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = today;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  //My added definitions;
  //loaded calendars are the ones that we will pull events from,
  //and events is the total list of events to display.
  //(maximum 4 per day)

  //used to build events viewing
  late final ValueNotifier<List<Event>> _selectedEvents;
  late final ValueNotifier<List<Event>> _loadedEvents;
  late List<bool> _highlightedEvents;

  late final List<Calendar> _loadedCalendars;
  late final List<bool> _calendarSelection;

  bool _copyEventMode = false;
  Event? _copyEvent;

  @override
  void initState() {
    super.initState();
    print("\n Initialization info: ");

    _selectedDay = _focusedDay;

    //initially loads all calendars supplied to the widget
    _loadedCalendars = widget.calendars.toList();
    for (var cal in _loadedCalendars) {
      print('_loadedCalendars has : ${cal.name} ');
    }
    _calendarSelection = List.filled(widget.calendars.length, true);

    //load events in active calendars
    _loadedEvents = ValueNotifier(_getAllEventsInCalendars());
    print(" _loadedEvents:");
    for (var event in _loadedEvents.value) {
      print("  ${event.dbgOutput()}");
    }

    _highlightedEvents = List.filled(_loadedEvents.value.length, false);

    //loads the selected events; initially today
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _loadedEvents.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  ///modifies the current list of loaded calendars
  ///by removing the calendar at the selected index.
  ///Then it adjusts the loaded events list/map accordingly.
  void _reloadCalendars(int index) {
    if (_loadedCalendars.contains(widget.calendars[index])) {
      _loadedCalendars.remove(widget.calendars[index]);
    } else {
      _loadedCalendars.add(widget.calendars[index]);
    }
    _loadedEvents.value = _getAllEventsInCalendars();
    _highlightedEvents = List.filled(_loadedEvents.value.length, false);

    if (_selectedDay != null) {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    }
  }

  ///reloads the events map and list
  ///use after there has been a change in the loaded calendars list.
  void _reloadEvents() {
    _loadedEvents.value = _getAllEventsInCalendars();
    _highlightedEvents = [..._highlightedEvents, false];

    if (_selectedDay != null) {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    }
  }

  ///Essential function; loads events for each day
  List<Event> _getEventsForDay(DateTime day) {
    final normalized = normalizeDate(day);
    return _mapAllEvents()[normalized] ?? [];
  }

  ///function for range selection event showing
  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return [for (final d in days) ..._getEventsForDay(d)];
  }

  ///background function: creates a list of all our active calendars
  List<Event> _getAllEventsInCalendars() {
    final List<Event> list = _loadedCalendars.fold(
      [],
      (prev, list) =>
          prev.isEmpty ? list.getEvents() : prev += list.getEvents(),
    );
    print('\n _getallevents returns: ');
    print(list);
    return list;
  }

  ///background function: creates a map of all events from a list
  /// Used for our calendarbuilder to create custom markers
  Map<DateTime, List<Event>> _mapAllEvents() {
    return _getAllEventsInCalendars().fold<Map<DateTime, List<Event>>>({}, (
      map,
      event,
    ) {
      final day = normalizeDate(event.time);
      print('*- call to _mapAllEvents -*');
      print('Event "${event.title}" mapped to $day');
      map.putIfAbsent(day, () => []).add(event);
      return map;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print('${DateFormat.yMMMd().format(_selectedDay!)} selected.');
    if (!isSameDay(_selectedDay, selectedDay)) {
      if (_copyEventMode) {
        _onDaySelectedCopyMode(selectedDay, focusedDay);
      } else {
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
  }

  void _onDaySelectedCopyMode(DateTime selectedDay, DateTime focusedDay) {
    int index = _loadedCalendars.indexWhere((calendar) {
      return calendar.events.values.any(
        (eventList) => eventList.contains(_copyEvent),
      );
    });
    if (index >= 0 &&
        selectedDay.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
      print(
        'sourceCalendar found: ${_loadedCalendars[index].name} & event is after yesterday',
      );
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _loadedCalendars[index] = _loadedCalendars[index].copyEventToDate(
          event: _copyEvent!,
          targetDate: _selectedDay!,
        );
        _reloadEvents();
        print(
          '${_copyEvent!.dbgOutput()} added to ${_loadedCalendars[index].name}',
        );
        //_selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    } else {
      print('sourceCalendar not found');
    }
  }

  ///pretty ignorable function
  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    if (_copyEventMode) return;
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

  //render a dialog box to pick a calendar for adding events.
  void _openEventBuilder() async {
    Calendar? calendar = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("select Calendar to add event to:"),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView.builder(
                itemCount: widget.calendars.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadiusDirectional.circular(12),
                    ),
                    child: ListTile(
                      title: Text(widget.calendars[index].name),
                      onTap: () {
                        Navigator.pop(context, widget.calendars[index]);
                      },
                    ),
                  );
                },
              ),
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
    );
    if (calendar == null) return;
    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder:
            (context) => EventsPage(title: calendar.name, calendar: calendar),
      ),
    );
  }

  //when a list tile is selected;
  void _onEventSelected(int index) {
    if (_copyEventMode) {
      setState(() {
        _copyEventMode = !_copyEventMode;
        _highlightedEvents = List.filled(_loadedEvents.value.length, false);
        _copyEvent = null;
      });
      for (var cal in _loadedCalendars) {
        print(cal.toString());
      }
    } else {
      setState(() {
        _copyEventMode = !_copyEventMode;
        _highlightedEvents[index] = !_highlightedEvents[index];
        //removed deep copy; seemed unnecessary
        _copyEvent = _loadedEvents.value[index];
      });
    }
  }

  Widget _editModeIndicator() {
    if (!_copyEventMode) return SizedBox.shrink();
    return FilledButton(
      onPressed: () => _onEventSelected(0),
      child: Row(children: [Icon(Icons.copy), Text("Copy")]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeshare'),
        elevation: 8,
        centerTitle: true,
        actions: [
          _editModeIndicator(),
          SizedBox(width: 10),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: Icon(Icons.menu),
              );
            },
          ),
        ],
      ),

      //End drawer for enabling/disabling calendars
      endDrawerEnableOpenDragGesture: false,
      endDrawer: Drawer(
        child: ListView.builder(
          itemCount: widget.calendars.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "loaded calendars: ",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Divider(),
                CheckboxListTile(
                  value: _calendarSelection[index],
                  title: Text(widget.calendars[index].name),
                  onChanged: (selection) {
                    setState(() {
                      _calendarSelection[index] = selection!;
                      _reloadCalendars(index);
                    });
                    print('checkbox toggled: $index → ${selection!}');
                    print('calendars length: ${widget.calendars.length}');
                    print('selection length: ${_calendarSelection.length}');
                  },
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close"),
                ),
              ],
            );
          },
        ),
      ),

      //the MEAT
      body: Column(
        children: [
          //names of active calendars;
          Center(
            child: Text(
              _loadedCalendars.fold(
                "Loaded Calendars: ",
                (prev, cal) => '$prev ${cal.name}, ',
              ),
            ),
          ),

          //The actual calendar viewing widget, which enables selection in
          //days or ranges.
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: today.subtract(const Duration(days: 365)),
            lastDay: today.add(const Duration(days: 365)),
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

          const SizedBox(height: 8.0),

          //currently can only support showing ALL events loaded;
          //plans to include selected events view as well
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _loadedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        selected: _highlightedEvents[index],
                        leading: Text(
                          DateFormat.yMMMd().format(value[index].time),
                        ),
                        title: Text(value[index].title),
                        trailing: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: value[index].color,
                            shape: value[index].shape,
                          ),
                        ),
                        onTap: () => _onEventSelected(index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: IconButton.filled(
        onPressed: _openEventBuilder,
        icon: Icon(Icons.edit),
      ),
    );
  }
}
