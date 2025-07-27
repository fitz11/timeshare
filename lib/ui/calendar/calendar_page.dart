import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/providers/sel_cal_providers.dart';
import 'package:timeshare/ui/calendar/wgts/calendar_widget.dart';
import 'package:timeshare/ui/calendar/wgts/event_list.dart';
import 'package:timeshare/ui/calendar/wgts/calendar_page_header.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsMap = ref.watch(visibleEventsMapProvider);
    return Column(
      children: [
        CalendarPageHeader(),

        CalendarWidget(eventsMap: eventsMap),

        const Divider(),

        EventList(),
      ],
    );
  }
}
