// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/friend_request/friend_request.dart';
import 'package:timeshare/providers/friend_request/friend_request_providers.dart';
import 'package:timeshare/utils/string_utils.dart';

/// Displays outgoing pending friend requests at the bottom of the friends page.
///
/// Shows a list of sent requests with a cancel button.
/// Hidden when there are no pending outgoing requests.
class OutgoingFriendRequestsSection extends ConsumerWidget {
  const OutgoingFriendRequestsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(sentFriendRequestsProvider);

    return requestsAsync.when(
      data: (requests) {
        final pendingRequests =
            requests.where((r) => r.isPendingAndValid).toList();

        if (pendingRequests.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Pending Sent Requests (${pendingRequests.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ...pendingRequests.map(
              (request) => _OutgoingFriendRequestCard(request: request),
            ),
          ],
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _OutgoingFriendRequestCard extends ConsumerWidget {
  final FriendRequest request;

  const _OutgoingFriendRequestCard({required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initials = getInitials(request.toDisplayName ?? '');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
          child: request.toPhotoUrl != null
              ? ClipOval(
                  child: Image.network(
                    request.toPhotoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Text(initials),
                  ),
                )
              : Text(
                  initials.isEmpty ? '?' : initials,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
        title: Text(request.toDisplayName ?? 'Unknown User'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (request.toEmail != null)
              Text(
                request.toEmail!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            Text(
              'Expires in ${request.daysUntilExpiry} days',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          color: Theme.of(context).colorScheme.error,
          tooltip: 'Cancel request',
          onPressed: () => _cancelRequest(context, ref),
        ),
      ),
    );
  }

  Future<void> _cancelRequest(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Friend Request'),
        content: Text(
          'Are you sure you want to cancel the friend request to ${request.toDisplayName ?? "this user"}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(friendRequestProvider.notifier).cancelRequest(
            requestId: request.id,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Friend request cancelled'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel request: $e'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
