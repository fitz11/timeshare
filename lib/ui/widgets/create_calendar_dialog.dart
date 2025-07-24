import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/providers/providers.dart';

void showCreateCalendarDialog(BuildContext context, WidgetRef ref) {
  final nameController = TextEditingController();

  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text("Create New Calendar"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Calendar Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                final uid = FirebaseAuth.instance.currentUser!.uid;

                await ref
                    .read(calendarNotifierProvider.notifier)
                    .addCalendar(ownerUid: uid, name: name);

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text("Create"),
            ),
          ],
        ),
  );
}
