import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/calendar/calendar.dart';
import 'package:timeshare/data/event/event.dart';
import 'package:timeshare/providers.dart';
import 'package:timeshare/ui/widgets/open_eventbuilder_dialog.dart';
import 'package:timeshare/util.dart';
import 'package:timeshare/ui/pages/eventspage.dart';
import 'package:timeshare/ui/widgets/create_calendar_dialog.dart';

//it is a dependency, don't let dartls lie to you
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarPage> {
  //BOILERPLATE DEFNINITIONS FOR THE CALENDAR WIDGET
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = today;
  DateTime? _selectedDay;

  //My definitions
  Event? _copiedEvent;
  bool _isCopyMode = false;

  @override
  void initState() {
    super.initState();

    // Fetch calendars on first build
    Future.microtask(() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await ref
            .read(calendarNotifierProvider.notifier)
            .loadAllCalendars(uid: user.uid);
      }
    });
  }

  //render a dialog box to pick a calendar for adding events.
  void _openEventBuilder(List<Calendar> calendars) async {
    Calendar? calendar = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("select Calendar to add event to:"),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView.builder(
                itemCount: calendars.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadiusDirectional.circular(12),
                    ),
                    child: ListTile(
                      title: Text(calendars[index].name),
                      onTap: () {
                        Navigator.pop(context, calendars[index]);
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
            (context) =>
                EventsPage(title: calendar.name, calendarId: calendar.id),
      ),
    );
  }

  //when a list tile is selected;
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      _selectedDay = selectedDay;
    });
    if (_isCopyMode && _copiedEvent != null) {
      final copied = _copiedEvent!;
      final newEvent = copied.copyWith(time: selectedDay);
      ref
          .read(calendarNotifierProvider.notifier)
          .addEventToCalendar(calendarId: copied.calendarId, event: newEvent);
    }
  }

  Widget _deleteButton(List<Event> events) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        final Event? toDelete = await showDialog<Event>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text("select Event to delete (this is permanent)"),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadiusDirectional.circular(12),
                        ),
                        child: ListTile(
                          title: Text(events[index].name),
                          onTap: () {
                            Navigator.pop(context, events[index]);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
        );
        if (toDelete != null) {
          ref
              .read(calendarNotifierProvider.notifier)
              .removeEvent(calendarId: toDelete.calendarId, event: toDelete);
        }
      },
    );
  }

  Widget _editModeIndicator() {
    if (!_isCopyMode) return SizedBox.shrink();
    return FilledButton(
      onPressed:
          () => setState(() {
            _isCopyMode = false;
            _copiedEvent = null;
          }),
      child: Row(children: [Icon(Icons.copy), Text(_copiedEvent!.name)]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allCalendars = ref.watch(calendarNotifierProvider);
    final selectedIds = ref.watch(selectedCalendarsProvider);
    final selectedCalendars = allCalendars.where(
      (cal) => selectedIds.contains(cal.id),
    );
    final eventsMap = ref.watch(visibleEventsMapProvider);
    final List<Event> eventsList = selectedCalendars.fold(
      [],
      (prev, list) =>
          prev.isEmpty ? list.getEvents() : prev += list.getEvents(),
    );

    List<Event> getEventsForDay(DateTime day) {
      final normalized = normalizeDate(day);
      return eventsMap[normalized] ?? [];
    }

    return Column(
      children: [
        //names of active calendars;
        Row(
          children: [
            Text(
              selectedCalendars.fold(
                "Loaded Calendars: ",
                (prev, cal) => '$prev ${cal.name}, ',
              ),
            ),
            _editModeIndicator(),
            FilledButton(
              onPressed: () {
                showCreateCalendarDialog(context, ref);
              },
              child: Row(children: [Icon(Icons.add), Text('New Calendar')]),
            ),
            FilledButton(
              onPressed: () {
                openEventBuilder(context, allCalendars);
              },
              child: Row(children: [Icon(Icons.add), Text('New Event')]),
            ),
            _deleteButton(eventsList),
          ],
        ),

        //The actual calendar viewing widget, which enables selection in
        //days or ranges.
        TableCalendar(
          focusedDay: _focusedDay,
          firstDay: today.subtract(const Duration(days: 365)),
          lastDay: today.add(const Duration(days: 365)),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: _calendarFormat,
          rangeSelectionMode: RangeSelectionMode.disabled,
          eventLoader: getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
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

        const Divider(),

        //currently can only support showing ALL events loaded;
        //plans to include selected events view as well
        Expanded(
          child: ListView.builder(
            itemCount: eventsList.length,
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
                  leading: Text(
                    DateFormat.yMMMd().format(eventsList[index].time),
                  ),
                  title: Text(eventsList[index].name),
                  trailing: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: eventsList[index].color,
                      shape: eventsList[index].shape,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _copiedEvent = eventsList[index];
                      _isCopyMode = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Copied '${eventsList[index].name}' - tap date to paste.",
                            ),
                            Text(
                              "Select the Edit mode indicator to leave copy mode.",
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
