import 'package:flutter/material.dart';
import 'package:timeshare/event.dart';
import 'package:timeshare/pages/calendarview.dart';

///this is a page that allows users to view/add events
/// to the provided event list.
class EventsPage extends StatefulWidget {
  const EventsPage({super.key, required this.title, required this.calendars});

  final String title;
  final List<Calendar> calendars;

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  //allows us to update or pass the active calendar back to our main view
  late ValueNotifier<Calendar> _activeCalendar;

  //fields the user selects to customize event markers
  bool _makeSquare = false;
  Color _selectedColor = Colors.black;
  DateTime? _selectedDate;
  String? _selectedName;

  late TextEditingController _eventNameController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _activeCalendar = ValueNotifier(widget.calendars[0]);
    _eventNameController = TextEditingController();
    _dateController = TextEditingController();
    _selectedDate = DateTime.now().add(Duration(days: 5));
    _dateController = TextEditingController(text: _selectedDate.toString());
  }

  @override
  void dispose() {
    _activeCalendar.dispose();
    _eventNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  //adds configured event to calendar
  void _onSubmitted() {
    print('$_selectedDate $_selectedName :: trying to add event...');
    _selectedName = _eventNameController.text;
    if (_selectedName!.isNotEmpty && _selectedDate != null) {
      BoxShape shape = _makeSquare ? BoxShape.rectangle : BoxShape.circle;
      Event event = Event(
        _selectedName!,
        _selectedDate!,
        color: _selectedColor,
        shape: shape,
      );
      _activeCalendar.value.addEvent(event);
      print('Event added!');
    } else {
      print('event not added :( ');
    }
    setState(() {
      _eventNameController.clear();
      _dateController.clear();
      _selectedDate = DateTime.now().add(Duration(days: 5));
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        print('selected date: $_selectedDate');
        _dateController.text = _selectedDate.toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar, has navigation
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 8,
        actions: [
          IconButton(
            onPressed:
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CalendarView(calendars: widget.calendars),
                  ),
                ),
            icon: Icon(Icons.calendar_month),
          ),
        ],
      ),

      //the MEAT
      body: Column(
        children: [
          //header
          Center(
            child: Text("Add event to ${_activeCalendar.value.name} calendar"),
          ),

          //naming and submission field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
              ),
              controller: _eventNameController,
            ),
          ),

          //field to choose date/time of event
          //TODO: split to make room to pick a time
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Checkbox(
                  value: _makeSquare,
                  onChanged: (_) {
                    setState(() {
                      _makeSquare = !_makeSquare;
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
          Center(
            child: FilledButton.tonal(
              onPressed: _onSubmitted,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              child: Row(children: [Icon(Icons.add), Text('Add to calendar')]),
            ),
          ),

          // This renders a list of the events in the calendar, silly!
          // the listview is scrollable, so don't sweat it
          Expanded(
            child: ValueListenableBuilder<Calendar>(
              valueListenable: _activeCalendar,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.getEvents().length,
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
                            Text("${value.getEvents()[index].time.day}-"),
                            Text("${value.getEvents()[index].time.month}"),
                            SizedBox(width: 20),
                            Text(
                              value.getEvents()[index].title,
                              style: TextStyle(
                                color: value.getEvents()[index].color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        leading: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: value.getEvents()[index].color,
                            shape: value.getEvents()[index].shape,
                          ),
                        ),
                        trailing: Text('${value.getEvents()[index].shape}'),

                        onTap: () {},
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
