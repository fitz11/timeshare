// Timeshare: a cross-platform app to make and share calendars.
// Copyright (C) 2025  David Fitzsimmons
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';

void showCreateCalendarDialog(BuildContext context, WidgetRef ref) {
  final nameController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Create New Calendar'),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(labelText: 'Calendar Name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final name = nameController.text.trim();
            if (name.isEmpty) return;

            final uid = FirebaseAuth.instance.currentUser!.uid;

            await ref
                .read(calendarMutationsProvider.notifier)
                .addCalendar(ownerUid: uid, name: name);

            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
          child: const Text('Create'),
        ),
      ],
    ),
  );
}
