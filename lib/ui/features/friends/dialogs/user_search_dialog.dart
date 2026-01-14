// SPDX-License-Identifier: AGPL-3.0-or-later
// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/services/api_client.dart';
import 'package:timeshare/providers/friend_request/friend_request_providers.dart';
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
            title: const Text('Search Users'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Search by email',
                    hintText: 'Tap a user to send friend request',
                  ),
                  onChanged: (value) {
                    if (debounceTimer?.isActive ?? false) {
                      debounceTimer!.cancel();
                    }
                    debounceTimer = Timer(
                      const Duration(milliseconds: 500),
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
                              trailing: const Icon(Icons.person_add_outlined),
                              onTap: () async {
                                try {
                                  await ref
                                      .read(friendRequestProvider.notifier)
                                      .sendRequest(targetUid: user.uid);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Friend request sent to ${user.displayName}',
                                      ),
                                      duration: const Duration(seconds: 5),
                                    ),
                                  );
                                } on ApiException catch (e) {
                                  // Handle specific error cases
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.message),
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                      duration: const Duration(seconds: 5),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to send request: $e'),
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                      duration: const Duration(seconds: 5),
                                    ),
                                  );
                                }
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
