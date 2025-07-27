import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/event/event.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/data/providers/cal_providers.dart';

void showDeleteDialog(
  BuildContext context,
  WidgetRef ref,
  List<Event> events,
) async {
  await showDialog<Event>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text("select Event to delete (this is permanent)"),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadiusDirectional.circular(12),
                  ),
                  child: ListTile(
                    title: Text(events[index].name),
                    subtitle: Text(
                      DateFormat.yMMMd().format(events[index].time),
                    ),
                    trailing: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: events[index].color,
                        shape: events[index].shape,
                      ),
                    ),
                    onTap: () {
                      ref
                          .read(calendarNotifierProvider.notifier)
                          .removeEvent(
                            calendarId: events[index].calendarId,
                            event: events[index],
                          );
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ),
  );
}
