// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/providers/nav/nav_providers.dart';
import 'package:timeshare/ui/core/responsive/responsive.dart';
import 'package:timeshare/ui/features/calendar/widgets/cal_drawer_content.dart';

/// Responsive navigation rail for tablet and desktop layouts.
class HomeNavRail extends ConsumerWidget {
  final ScreenSize screenSize;

  const HomeNavRail({super.key, required this.screenSize});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);
    final extended = screenSize == ScreenSize.desktop;
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationRail(
      extended: extended,
      selectedIndex: currentIndex.index,
      onDestinationSelected: (index) {
        ref.read(navIndexProvider.notifier).updateWithInt(index);
      },
      labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
      leading: extended
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 32,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'TimeShare',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Icon(
                Icons.calendar_month,
                size: 32,
                color: colorScheme.primary,
              ),
            ),
      trailing: currentIndex == HomePages.calendar
          ? Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: extended
                      // SizedBox provides width constraints for SwitchListTile
                      ? const SizedBox(
                          width: 280,
                          child: CalDrawerContent(),
                        )
                      : IconButton(
                          icon: const Icon(Icons.settings),
                          tooltip: 'Calendar settings',
                          onPressed: () {
                            _showSettingsBottomSheet(context);
                          },
                        ),
                ),
              ),
            )
          : null,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profile'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.calendar_today_outlined),
          selectedIcon: Icon(Icons.calendar_today),
          label: Text('Calendar'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.group_outlined),
          selectedIcon: Icon(Icons.group),
          label: Text('Friends'),
        ),
      ],
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: CalDrawerContent(),
      ),
    );
  }
}
