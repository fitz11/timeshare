import 'package:flutter/material.dart';
import 'package:timeshare/pages/calendarview.dart';
import 'package:timeshare/util.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key, required this.title});

  final String title;

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late final ValueNotifier<List<Event>> _userEvents;

  late TextEditingController _eventNameController;

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController();
    _userEvents = ValueNotifier(userEvents);
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _userEvents.dispose();
    super.dispose();
  }

  void _onSubmitted(String value) {
    if (value.isEmpty) return;
    for (Event event in _userEvents.value) {
      if (event.title == value) return;
    }
    _userEvents.value.add(Event(value));
    setState(() {
      _eventNameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CalendarView()),
                ),
            icon: Icon(Icons.calendar_month),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(child: Text("hello! Let's make some events!")),
          TextField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.add),
              labelText: 'Event Name',
              border: OutlineInputBorder(),
            ),
            controller: _eventNameController,
            onSubmitted: _onSubmitted,
          ),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _userEvents,
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
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userEvents = _userEvents.value;
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
