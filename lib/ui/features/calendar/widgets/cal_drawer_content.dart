// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:timeshare/ui/features/calendar/widgets/aftertoday_toggle.dart';

/// The settings content from CalDrawer, extracted for reuse in NavigationRail.
class CalDrawerContent extends StatelessWidget {
  const CalDrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
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
    );
  }
}
