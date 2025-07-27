import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/calendar/calendar.dart';
import 'package:timeshare/data/providers/sel_cal_providers.dart';
import 'package:timeshare/ui/core/buttons/delete_event_button.dart';

class ListHeader extends ConsumerWidget {
  const ListHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Calendar> selectedCals = ref.watch(selectedCalendarsProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [DeleteButton()],
    );
  }
}
