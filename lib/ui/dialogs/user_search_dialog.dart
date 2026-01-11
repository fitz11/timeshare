// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/user/user_providers.dart';
import 'package:timeshare/utils/error_utils.dart';

void showUserSearchDialog(BuildContext context, WidgetRef ref) {
  final controller = TextEditingController();
  String query = '';
  Timer? debounceTimer;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Search Users: Tap to add friend'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Search by email',
                  ),
                  onChanged: (value) {
                    if (debounceTimer?.isActive ?? false) {
                      debounceTimer!.cancel();
                    }
                    debounceTimer = Timer(
                      const Duration(milliseconds: 400),
                      () {
                        setState(() {
                          query = value.trim();
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final asyncUsers = ref.watch(userSearchProvider(query));

                      return asyncUsers.when(
                        data: (users) => ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return ListTile(
                              title: Text(user.displayName),
                              subtitle: Text(user.email),
                              onTap: () async {
                                await ref
                                    .read(userRepositoryProvider)
                                    .addFriend(user.uid);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${user.displayName} * ${user.email} added as a friend!',
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, st) => Center(child: Text(formatError(e))),
                      );
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    },
  );
}
