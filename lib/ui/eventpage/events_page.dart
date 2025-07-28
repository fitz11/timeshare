import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/calendar/calendar.dart';
import 'package:timeshare/data/event/event.dart';

//note: dartls does not recognize that the DateFormat lib
//is in this import, so it thinks it has to go. I need it
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/data/providers/cal/cal_providers.dart';

///this is a page that allows users to view/add events
/// to the provided event list.
class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key, required this.title, required this.calendarId});

  final String title;
  final String calendarId;

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  //allows us to update or pass the active calendar back to our main view
  bool _canSubmit = false;

  //fields the user selects to customize event markers
  bool _makeSquare = false;
  Color _selectedColor = Colors.black;

  late TextEditingController _eventNameController;
  late TextEditingController _dateController;
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController();
    _dateController = TextEditingController();
    _selectedDate = normalizeDate(DateTime.now());
    _dateController = TextEditingController(
      text: DateFormat.yMMMd().format(normalizeDate(_selectedDate!)),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  //adds configured event to calendar
  void _onSubmitted() async {
    String selectedName = _eventNameController.text;
    print('$_selectedDate - $selectedName :: trying to add event...');
    if (selectedName.isNotEmpty && _selectedDate != null) {
      BoxShape shape = _makeSquare ? BoxShape.rectangle : BoxShape.circle;
      Event newEvent = Event(
        name: selectedName,
        calendarId: widget.calendarId,
        time: _selectedDate!,
        color: _selectedColor,
        shape: shape,
      );

      final calendars = ref.read(calendarNotifierProvider).requireValue;
      for (final cal in calendars) {
        for (final event in cal.getEvents()) {
          if (event == newEvent) {
            print('Event already exists :P');
            return;
          }
        }
      }

      await ref
          .read(calendarNotifierProvider.notifier)
          .addEventToCalendar(calendarId: widget.calendarId, event: newEvent);
      print('Event added!\n}');
    } else {
      print('event not added :( ');
    }
    setState(() {
      _eventNameController.clear();
      _dateController.clear();
      _selectedDate = null;
      _canSubmit = false;
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    _selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (_selectedDate != null) {
      setState(() {
        print('selected date: $_selectedDate');
        _dateController.text = DateFormat.yMMMd().format(_selectedDate!);
        if (_selectedDate != null && _eventNameController.text.isNotEmpty) {
          setState(() {
            _canSubmit = true;
          });
        } else {
          setState(() {
            _canSubmit = false;
          });
        }
      });
    }
  }

  //help for string/color conversion
  String colorToName(Color color) {
    if (color == Colors.black) {
      return 'Black';
    } else if (color == Colors.red) {
      return 'Red';
    } else if (color == Colors.blue) {
      return 'Blue';
    } else {
      return 'Green';
    }
  }

  Widget submitButton() {
    if (_canSubmit) {
      return FilledButton.tonal(
        onPressed: _onSubmitted,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.add), Text('Add to calendar')],
        ),
      );
    } else {
      return OutlinedButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.add), Text('Add to calendar')],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final calendar = ref
        .watch(calendarNotifierProvider)
        .requireValue
        .firstWhere((cal) => cal.id == widget.calendarId);
    return Scaffold(
      //AppBar, has navigation
      appBar: AppBar(
        title: Text(calendar.name),
        centerTitle: true,
        elevation: 8,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.calendar_month),
          ),
        ],
      ),

      //the MEAT
      body: Column(
        children: [
          //header
          Center(child: Text("Add event to ${calendar.name} calendar")),

          //naming and submission field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
              ),
              controller: _eventNameController,
              onChanged: (s) {
                if (_selectedDate != null &&
                    _eventNameController.text.isNotEmpty) {
                  setState(() {
                    _canSubmit = true;
                  });
                } else {
                  setState(() {
                    _canSubmit = false;
                  });
                }
              },
            ),
          ),

          //field to choose date/time of event
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _dateController,
              readOnly: true,
              maxLength: 30,
              decoration: const InputDecoration(
                labelText: 'Pick a date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _pickDate(context),
            ),
          ),

          //Field to determine shape of our event
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _makeSquare,
                  onChanged: (newVal) {
                    setState(() {
                      _makeSquare = newVal!;
                    });
                  },
                ),
                Text('Make it a square!'),
              ],
            ),
          ),

          //field to choose the color of our event
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Select a color: '),
                SizedBox(width: 20),
                DropdownButton<Color>(
                  value: _selectedColor,
                  items:
                      [Colors.black, Colors.red, Colors.blue, Colors.green].map(
                        (Color color) {
                          return DropdownMenuItem<Color>(
                            value: color,
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black26),
                                  ),
                                ),
                                Text(colorToName(color)),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                  onChanged: (Color? newColor) {
                    setState(() {
                      _selectedColor = newColor!;
                    });
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          //The submit button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Center(child: submitButton()),
          ),

          Divider(),

          // This renders a list of the events in the calendar, silly!
          // the listview is scrollable, so don't sweat it
          Expanded(
            child: ListView.builder(
              itemCount: calendar.getEvents().length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    // onTap: () => print('${value[index]}'),
                    title: Row(
                      children: [
                        Text(
                          DateFormat.yMMMd().format(
                            calendar.getEvents()[index].time,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          calendar.getEvents()[index].name,
                          style: TextStyle(
                            color: calendar.getEvents()[index].color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    leading: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: calendar.getEvents()[index].color,
                        shape: calendar.getEvents()[index].shape,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
