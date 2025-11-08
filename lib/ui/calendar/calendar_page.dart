import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/providers/cal/cal_providers.dart';
import 'package:timeshare/ui/calendar/wgts/calendar_widget.dart';
import 'package:timeshare/ui/calendar/wgts/event_list.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsMap = ref.watch(visibleEventsMapProvider);
    final eventsList = ref.watch(visibleEventsListProvider);
    return Column(
      children: [
        CalendarWidget(eventsMap: eventsMap),

        const Divider(),

        EventList(eventsList: eventsList),
      ],
    );
  }
}
