// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/friend_request/friend_request.dart';
import 'package:timeshare/providers/friend_request/friend_request_providers.dart';
import 'package:timeshare/utils/string_utils.dart';

/// Displays incoming friend requests at the top of the friends page.
///
/// Shows a list of pending requests with accept/decline buttons.
/// Hidden when there are no pending requests.
class FriendRequestsSection extends ConsumerWidget {
  const FriendRequestsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(incomingFriendRequestsProvider);

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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Friend Requests (${pendingRequests.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ...pendingRequests.map(
              (request) => _FriendRequestCard(request: request),
            ),
            const Divider(height: 24),
          ],
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _FriendRequestCard extends ConsumerWidget {
  final FriendRequest request;

  const _FriendRequestCard({required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initials = getInitials(request.fromDisplayName ?? '');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          child: request.fromPhotoUrl != null
              ? ClipOval(
                  child: Image.network(
                    request.fromPhotoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Text(initials),
                  ),
                )
              : Text(
                  initials.isEmpty ? '?' : initials,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
        title: Text(request.fromDisplayName ?? 'Unknown User'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (request.fromEmail != null)
              Text(
                request.fromEmail!,
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check),
              color: Colors.green,
              tooltip: 'Accept',
              onPressed: () => _acceptRequest(context, ref),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: Colors.red,
              tooltip: 'Decline',
              onPressed: () => _declineRequest(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _acceptRequest(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(friendRequestProvider.notifier).acceptRequest(
            requestId: request.id,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${request.fromDisplayName ?? "User"} added as friend',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to accept request: $e')),
        );
      }
    }
  }

  Future<void> _declineRequest(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(friendRequestProvider.notifier).declineRequest(
            requestId: request.id,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request declined')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to decline request: $e')),
        );
      }
    }
  }
}
