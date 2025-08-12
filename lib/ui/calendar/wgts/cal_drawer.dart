import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/ui/core/buttons/delete_event_button.dart';
import 'package:timeshare/ui/core/buttons/new_cal_button.dart';
import 'package:timeshare/ui/core/buttons/new_event_button.dart';

class CalDrawer extends ConsumerWidget {
  const CalDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 60,
            child: const DrawerHeader(child: Text('Edit Calendar')),
          ),
          NewCalButton(),
          NewEventButton(),
          DeleteButton(),
        ],
      ),
    );
  }
}
