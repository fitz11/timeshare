// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/ownership_transfer/ownership_transfer_request.dart';
import 'package:timeshare/providers/ownership_transfer/ownership_transfer_providers.dart';

/// Displays incoming ownership transfer requests.
///
/// Can be added to the Friends page or a notifications area.
/// Shows pending transfer requests with accept/decline buttons.
class OwnershipTransferSection extends ConsumerWidget {
  const OwnershipTransferSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfersAsync = ref.watch(incomingOwnershipTransfersProvider);

    return transfersAsync.when(
      data: (transfers) {
        final pendingTransfers =
            transfers.where((t) => t.isPending).toList();

        if (pendingTransfers.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Ownership Transfers (${pendingTransfers.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ...pendingTransfers.map(
              (transfer) => _OwnershipTransferCard(transfer: transfer),
            ),
            const Divider(height: 24),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _OwnershipTransferCard extends ConsumerWidget {
  final OwnershipTransferRequest transfer;

  const _OwnershipTransferCard({required this.transfer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
          child: const Icon(Icons.swap_horiz),
        ),
        title: Text(transfer.calendarName),
        subtitle: Text(
          'From: ${transfer.fromDisplayName ?? "Unknown"}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check),
              color: Colors.green,
              tooltip: 'Accept ownership',
              onPressed: () => _acceptTransfer(context, ref),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: Colors.red,
              tooltip: 'Decline',
              onPressed: () => _declineTransfer(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _acceptTransfer(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(ownershipTransferProvider.notifier).acceptTransfer(
            requestId: transfer.id,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You are now the owner of "${transfer.calendarName}"',
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to accept transfer: $e'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _declineTransfer(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(ownershipTransferProvider.notifier)
          .declineTransfer(requestId: transfer.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfer declined'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to decline transfer: $e'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
