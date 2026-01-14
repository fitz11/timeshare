// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/models/event/event_recurrence.dart';
import 'package:timeshare/data/enums.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/ui/features/calendar/dialogs/edit_event_dialog.dart';

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
    // Repeating events open editor instead of copy mode
    if (event.recurrence != EventRecurrence.none) {
      _openEditDialog(context, ref);
      return;
    }

    ref.read(interactionModeStateProvider.notifier).setCopy();
    ref.read(copyEventStateProvider.notifier).set(event);
    _showSnackBar(context, ref);
  }

  void _openEditDialog(BuildContext context, WidgetRef ref) {
    // Fetch source event (with original start time) rather than expanded occurrence
    final sourceEvent = ref.read(sourceEventProvider(event.id));
    if (sourceEvent == null) return;

    showDialog(
      context: context,
      builder: (context) => EditEventDialog(event: sourceEvent),
    );
  }

  void _showSnackBar(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            const Icon(Icons.copy, color: Colors.white, size: 20),
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
            ref.read(copyEventStateProvider.notifier).clear();
            ref.read(interactionModeStateProvider.notifier).setNormal();
          },
        ),
      ),
    );
  }

  String _recurrenceToShortLabel(EventRecurrence recurrence) {
    switch (recurrence) {
      case EventRecurrence.none:
        return '';
      case EventRecurrence.daily:
        return 'Daily';
      case EventRecurrence.weekly:
        return 'Weekly';
      case EventRecurrence.monthly:
        return 'Monthly';
      case EventRecurrence.yearly:
        return 'Yearly';
    }
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
          // Recurrence indicator
          if (event.recurrence != EventRecurrence.none) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.repeat,
              size: 12,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 2),
            Text(
              _recurrenceToShortLabel(event.recurrence),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
