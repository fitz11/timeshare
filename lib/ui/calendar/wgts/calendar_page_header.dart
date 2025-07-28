import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/ui/calendar/wgts/copymode_indicator.dart';
import 'package:timeshare/ui/core/buttons/new_cal_button.dart';
import 'package:timeshare/ui/core/buttons/new_event_button.dart';

///CURRENTLY UNUSED///
class CalendarPageHeader extends ConsumerWidget {
  const CalendarPageHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [CopyModeIndicator(), NewCalButton(), NewEventButton()],
      ),
    );
  }
}
