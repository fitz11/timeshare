import 'package:flutter/material.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/ui/calendar/wgts/event_list_item.dart';

class EventList extends StatelessWidget {
  const EventList({
    super.key,
    required this.eventsList,
    required this.selectedDay,
  });
  final List<Event> eventsList;
  final DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: eventsList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: EventListItem(event: eventsList[index]),
          );
        },
      ),
    );
  }
}
