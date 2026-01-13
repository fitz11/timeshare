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
  /// Whether to wrap the content in Expanded widget.
  /// Set to true for Column layout (mobile), false for Row layout (tablet/desktop).
  final bool useExpanded;

  const EventList({super.key, this.useExpanded = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleEvents = ref.watch(visibleEventsProvider);
    final copyMode = ref.watch(interactionModeStateProvider);
    final calendarNames = ref.watch(calendarNamesMapProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use pre-grouped map from provider (already filtered and sorted)
    final groupedEvents = visibleEvents.map;

    if (groupedEvents.isEmpty) {
      final emptyState = Center(
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
      );
      return useExpanded ? Expanded(child: emptyState) : emptyState;
    }

    // Sort dates chronologically
    final dates = groupedEvents.keys.toList()..sort();

    final listView = ListView.builder(
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
                  calendarNames,
                )),
          ],
        );
      },
    );

    return useExpanded ? Expanded(child: listView) : listView;
  }

  Widget _buildEventItem(
    BuildContext context,
    WidgetRef ref,
    Event event,
    InteractionMode copyMode,
    ColorScheme colorScheme,
    Map<String, String> calendarNames,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          hoverColor: colorScheme.primary.withValues(alpha: 0.08),
          onTap: () {}, // EventListItem handles taps internally
          child: EventListItem(
            event: event,
            showDate: false,
            calendarName: calendarNames[event.calendarId],
          ),
        ),
      ),
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
