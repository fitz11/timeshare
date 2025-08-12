import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/providers/cal/cal_providers.dart';
import 'package:timeshare/data/models/user/app_user.dart';

void showShareCalendarDialog(
  BuildContext context,
  WidgetRef ref,
  AppUser friend,
) {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final calendars =
      ref
          .read(calendarNotifierProvider)
          .requireValue
          .where((cal) => cal.owner == currentUserId)
          .toList();

  final Map<String, bool> sharedMap = {
    for (var cal in calendars) cal.id: cal.sharedWith.contains(friend.uid),
  };

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Share Calendars with ${friend.displayName}'),
            content: SizedBox(
              width: 300,
              height: 400,
              child: ListView(
                children:
                    calendars.map((calendar) {
                      final isShared = sharedMap[calendar.id] ?? false;
                      return CheckboxListTile(
                        title: Text(calendar.name),
                        value: isShared,
                        onChanged: (value) async {
                          if (value == null) return;

                          setState(() {
                            sharedMap[calendar.id] = value;
                          });

                          await ref
                              .read(calendarNotifierProvider.notifier)
                              .shareCalendar(calendar.id, friend.uid, value);
                        },
                      );
                    }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    },
  );
}
