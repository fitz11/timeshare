// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/user/app_user.dart';
import 'package:timeshare/providers/user/user_providers.dart';
import 'package:timeshare/ui/features/calendar/dialogs/share_calendar_dialog.dart';
import 'package:timeshare/utils/error_utils.dart';

class FriendsPage extends ConsumerWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friends = ref.watch(userFriendsProvider);

    return friends.when(
      data: (friendsList) {
        if (friendsList.isEmpty) {
          return _buildEmptyState(context);
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(userFriendsProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: friendsList.length,
            itemBuilder: (context, index) {
              final friend = friendsList[index];
              return _buildFriendCard(context, ref, friend);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _buildErrorState(context, ref, error),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 24),
            Text(
              'No Friends Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Search for users to add them as friends',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load friends',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              formatError(error),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.invalidate(userFriendsProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendCard(BuildContext context, WidgetRef ref, AppUser friend) {
    // Get initials for avatar
    final initials = friend.displayName
        .split(' ')
        .map((n) => n.isNotEmpty ? n[0].toUpperCase() : '')
        .take(2)
        .join();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          child: friend.photoUrl != null
              ? ClipOval(
                  child: Image.network(
                    friend.photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Text(initials),
                  ),
                )
              : Text(
                  initials.isEmpty ? '?' : initials,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
        title: Text(
          friend.displayName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          friend.email,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Share calendars',
              onPressed: () {
                showShareCalendarDialog(context, ref, friend);
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'remove') {
                  _showRemoveFriendDialog(context, ref, friend);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.person_remove, size: 20),
                      SizedBox(width: 8),
                      Text('Remove friend'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveFriendDialog(
    BuildContext context,
    WidgetRef ref,
    AppUser friend,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Friend'),
        content: Text(
          'Are you sure you want to remove ${friend.displayName} from your friends list?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(userFriendsProvider.notifier)
                  .removeFriend(targetUid: friend.uid);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${friend.displayName} removed from friends'),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
