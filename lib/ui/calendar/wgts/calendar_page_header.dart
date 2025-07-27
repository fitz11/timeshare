import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/calendar/calendar.dart';
import 'package:timeshare/data/providers/cal_providers.dart';
import 'package:timeshare/data/providers/sel_cal_providers.dart';
import 'package:timeshare/ui/calendar/wgts/copymode_indicator.dart';
import 'package:timeshare/ui/calendar/wgts/delete_button.dart';
import 'package:timeshare/ui/widgets/create_calendar_dialog.dart';
import 'package:timeshare/ui/widgets/open_eventbuilder_dialog.dart';

class CalendarPageHeader extends ConsumerWidget {
  const CalendarPageHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Calendar> allCalendars =
        ref.watch(calendarNotifierProvider).requireValue;
    final List<Calendar> selectedCals = ref.watch(selectedCalendarsProvider);
    return Column(
      children: [
        Center(
          child: Text(
            selectedCals.fold(
              "Loaded Calendars:",
              (prev, cal) => '$prev  ${cal.name}',
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CopyModeIndicator(),
            FilledButton(
              onPressed: () {
                showCreateCalendarDialog(context, ref);
              },
              child: Row(
                children: [Icon(Icons.calendar_month), Text('New Calendar')],
              ),
            ),
            FilledButton.tonal(
              onPressed: () {
                openEventBuilder(context, allCalendars);
              },
              child: Row(
                children: [Icon(Icons.calendar_today), Text('New Event')],
              ),
            ),
            DeleteButton(),
          ],
        ),
      ],
    );
  }
}
