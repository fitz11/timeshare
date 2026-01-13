// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/ui/features/calendar/widgets/event_list_item.dart';

class EventList extends ConsumerWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsList = ref.watch(visibleEventsProvider).list;
    final copyMode = ref.watch(interactionModeStateProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (eventsList.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_available,
                size: 64,
                color: colorScheme.outlineVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No events',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap + to create your first event',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Group events by date
    final groupedEvents = _groupEventsByDate(eventsList);
    final dates = groupedEvents.keys.toList();

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80), // Space for FAB
        itemCount: dates.length,
        itemBuilder: (context, dateIndex) {
          final date = dates[dateIndex];
          final events = groupedEvents[date]!;
          final isToday = _isToday(date);
          final isTomorrow = _isTomorrow(date);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isToday
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _formatDateHeader(date, isToday, isTomorrow),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: isToday
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${events.length} event${events.length == 1 ? '' : 's'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              // Events for this date
              ...events.map((event) => _buildEventItem(
                    context,
                    ref,
                    event,
                    copyMode,
                    colorScheme,
                  )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEventItem(
    BuildContext context,
    WidgetRef ref,
    Event event,
    InteractionMode copyMode,
    ColorScheme colorScheme,
  ) {
    final item = Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: EventListItem(event: event, showDate: false),
    );

    if (copyMode == InteractionMode.normal) {
      return Dismissible(
        key: ValueKey(event.id),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: Icon(Icons.delete, color: colorScheme.onErrorContainer),
        ),
        confirmDismiss: (_) async {
          return await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Delete Event'),
              content: Text('Delete "${event.name}"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
        },
        onDismissed: (_) {
          if (event.calendarId != null) {
            ref.read(calendarMutationsProvider.notifier).deleteEvent(
                  calendarId: event.calendarId!,
                  eventId: event.id,
                );
          }
        },
        child: item,
      );
    }

    return item;
  }

  Map<DateTime, List<Event>> _groupEventsByDate(List<Event> events) {
    final grouped = <DateTime, List<Event>>{};
    for (final event in events) {
      final dateOnly = DateTime(
        event.time.year,
        event.time.month,
        event.time.day,
      );
      grouped.putIfAbsent(dateOnly, () => []).add(event);
    }
    // Sort events within each date by time
    for (final events in grouped.values) {
      events.sort((a, b) => a.time.compareTo(b.time));
    }
    return grouped;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  String _formatDateHeader(DateTime date, bool isToday, bool isTomorrow) {
    if (isToday) return 'Today';
    if (isTomorrow) return 'Tomorrow';
    return DateFormat.MMMEd().format(date);
  }
}
