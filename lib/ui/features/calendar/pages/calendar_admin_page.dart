// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/user/app_user.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/providers/ownership_transfer/ownership_transfer_providers.dart';
import 'package:timeshare/providers/user/user_providers.dart';
import 'package:timeshare/utils/string_utils.dart';

/// Admin page for managing calendar access and ownership.
///
/// Shows:
/// - Calendar owner information
/// - List of users with access (sharedWith)
/// - Visual indicator for users not in friend list
/// - Ability to revoke access
/// - Ownership transfer (for owners only)
class CalendarAdminPage extends ConsumerWidget {
  final String calendarId;

  const CalendarAdminPage({required this.calendarId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarsAsync = ref.watch(calendarsProvider);
    final friendsAsync = ref.watch(userFriendsProvider);
    final currentUserId = ref.watch(currentUserIdProvider);

    return calendarsAsync.when(
      data: (calendars) {
        final calendar = calendars.where((c) => c.id == calendarId).firstOrNull;
        if (calendar == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Calendar Not Found')),
            body: const Center(child: Text('Calendar not found')),
          );
        }

        final isOwner = calendar.owner == currentUserId;
        final friends = friendsAsync.value ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Text(calendar.name),
          ),
          body: ListView(
            children: [
              _buildOwnerSection(context, ref, calendar, isOwner),
              const Divider(),
              _buildSharedWithSection(context, ref, calendar, friends, isOwner),
              if (isOwner) ...[
                const Divider(),
                _buildTransferSection(context, ref, calendar, friends),
              ],
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildOwnerSection(
    BuildContext context,
    WidgetRef ref,
    Calendar calendar,
    bool isOwner,
  ) {
    return FutureBuilder<AppUser?>(
      future: ref.read(userRepositoryProvider).getUserById(calendar.owner),
      builder: (context, snapshot) {
        final owner = snapshot.data;
        return ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Owner'),
          subtitle: Text(owner?.displayName ?? 'Loading...'),
          trailing: isOwner
              ? Chip(
                  label: const Text('You'),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                )
              : null,
        );
      },
    );
  }

  Widget _buildSharedWithSection(
    BuildContext context,
    WidgetRef ref,
    Calendar calendar,
    List<AppUser> friends,
    bool isOwner,
  ) {
    final friendUids = friends.map((f) => f.uid).toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Shared With (${calendar.sharedWith.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        if (calendar.sharedWith.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Not shared with anyone'),
          )
        else
          ...calendar.sharedWith.map((uid) {
            final isFriend = friendUids.contains(uid);
            return _SharedUserTile(
              uid: uid,
              isFriend: isFriend,
              isOwner: isOwner,
              calendarId: calendar.id,
            );
          }),
      ],
    );
  }

  Widget _buildTransferSection(
    BuildContext context,
    WidgetRef ref,
    Calendar calendar,
    List<AppUser> friends,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Transfer Ownership',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Transfer this calendar to another user. They must accept the transfer before becoming the new owner.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FilledButton.icon(
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Transfer to...'),
            onPressed: friends.isEmpty
                ? null
                : () => _showTransferDialog(context, ref, calendar, friends),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showTransferDialog(
    BuildContext context,
    WidgetRef ref,
    Calendar calendar,
    List<AppUser> friends,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Transfer Ownership'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              final initials = getInitials(friend.displayName);
              return ListTile(
                leading: CircleAvatar(
                  child: Text(initials.isEmpty ? '?' : initials),
                ),
                title: Text(friend.displayName),
                subtitle: Text(friend.email),
                onTap: () async {
                  try {
                    await ref
                        .read(ownershipTransferProvider.notifier)
                        .requestTransfer(
                          calendarId: calendar.id,
                          toUid: friend.uid,
                        );
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Transfer request sent to ${friend.displayName}',
                          ),
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to send request: $e'),
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    }
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

/// Tile showing a user with access to the calendar.
class _SharedUserTile extends ConsumerWidget {
  final String uid;
  final bool isFriend;
  final bool isOwner;
  final String calendarId;

  const _SharedUserTile({
    required this.uid,
    required this.isFriend,
    required this.isOwner,
    required this.calendarId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<AppUser?>(
      future: ref.read(userRepositoryProvider).getUserById(uid),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final initials = getInitials(user?.displayName ?? '');

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            foregroundColor:
                Theme.of(context).colorScheme.onSecondaryContainer,
            child: Text(initials.isEmpty ? '?' : initials),
          ),
          title: Text(user?.displayName ?? 'Loading...'),
          subtitle: Row(
            children: [
              if (user?.email != null)
                Expanded(
                  child: Text(
                    user!.email,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (!isFriend)
                Chip(
                  label: const Text('Not a friend'),
                  labelStyle: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.errorContainer,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
            ],
          ),
          trailing: isOwner
              ? IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  tooltip: 'Revoke access',
                  onPressed: () =>
                      _showRevokeDialog(context, ref, user?.displayName),
                )
              : null,
        );
      },
    );
  }

  void _showRevokeDialog(
    BuildContext context,
    WidgetRef ref,
    String? displayName,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke Access'),
        content:
            Text('Remove ${displayName ?? 'this user'} from this calendar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(calendarMutationsProvider.notifier).shareCalendar(
                    calendarId,
                    uid,
                    false,
                  );
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Access revoked for ${displayName ?? "user"}'),
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
  }
}
