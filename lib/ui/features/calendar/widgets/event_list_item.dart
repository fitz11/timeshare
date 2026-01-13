// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/enums.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';

class EventListItem extends ConsumerWidget {
  final Event event;
  final bool showDate;
  final String? calendarName;

  const EventListItem({
    super.key,
    required this.event,
    this.showDate = true,
    this.calendarName,
  });

  void _onTap(BuildContext context, WidgetRef ref) {
    ref.read(interactionModeStateProvider.notifier).setCopy();
    ref.read(copyEventStateProvider.notifier).set(event);
    _showSnackBar(context);
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(Icons.copy, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Tap a date to paste '${event.name}'",
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Cancel',
          onPressed: () {
            // Reset copy mode handled by provider
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copyMode = ref.watch(interactionModeStateProvider);
    final copiedEvent = ref.watch(copyEventStateProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Check if this event is the one being copied (Freezed provides value equality)
    final isCopied =
        copyMode == InteractionMode.copy &&
        copiedEvent != null &&
        copiedEvent == event;

    // Use passed name or look up via scoped provider (avoids watching all calendars)
    final String displayCalendarName =
        calendarName ?? ref.watch(calendarNameProvider(event.calendarId ?? ''));

    // Format time if available
    final timeStr = DateFormat.jm().format(event.time);
    final dateStr = DateFormat.MMMd().format(event.time);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: event.color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: event.color,
              shape: event.shape,
            ),
          ),
        ),
      ),
      title: Text(
        event.name,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 12,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              displayCalendarName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (showDate)
            Text(
              dateStr,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          Text(
            timeStr,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      // Highlight when copied with theme-aware colors
      tileColor: isCopied ? colorScheme.primaryContainer : null,
      shape: isCopied
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: colorScheme.primary, width: 2),
            )
          : null,
      onTap: () => _onTap(context, ref),
    );
  }
}
