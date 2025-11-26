import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/ui/calendar/wgts/aftertoday_toggle.dart';

class CalDrawer extends ConsumerWidget {
  const CalDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Enhanced drawer header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 48,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 8),
                Text(
                  'Calendar',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage your calendars and events',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),

          // Create section ---CURRENTLY DEPRECATED---
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          //   child: Text(
          //     'Create',
          //     style: Theme.of(context).textTheme.labelLarge?.copyWith(
          //       color: Theme.of(context).colorScheme.onSurfaceVariant,
          //     ),
          //   ),
          // ),
          // const NewCalButton(),
          // const SizedBox(height: 4),
          // const NewEventButton(),
          //
          // const Divider(),

          // Manage section ---CURRENTLY DEPRECATED---
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          //   child: Text(
          //     'Manage',
          //     style: Theme.of(context).textTheme.labelLarge?.copyWith(
          //           color: Theme.of(context).colorScheme.onSurfaceVariant,
          //         ),
          //   ),
          // ),
          // const DeleteButton(),
          //
          // const Divider(),

          // Settings section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const AfterTodayToggle(),
        ],
      ),
    );
  }
}
