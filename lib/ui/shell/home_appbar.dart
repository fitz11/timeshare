// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/providers/nav/nav_providers.dart';
import 'package:timeshare/ui/features/calendar/widgets/calendar_filter_dialog.dart';
import 'package:timeshare/ui/features/friends/dialogs/user_search_dialog.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  /// Whether to show the drawer menu button on calendar page.
  /// Set to false when NavigationRail is visible on tablet/desktop.
  final bool showMenuButton;

  const HomeAppBar({super.key, this.showMenuButton = true});

  ///builds app bar actions based on state
  List<Widget> _buildActionsForIndex(
    BuildContext context,
    WidgetRef ref,
    HomePages page,
  ) {
    //switch to support more actions as needed
    switch (page) {
      case HomePages.calendar:
        return [calFilterButton(context)];
      case HomePages.friends:
        return [friendSearchButton(context, ref)];
      default:
        return [];
    }
  }

  Widget? _buildLeadingForIndex(BuildContext context, HomePages page) {
    if (!showMenuButton) return null;
    switch (page) {
      case HomePages.calendar:
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(navIndexProvider);
    final title = page.name[0].toUpperCase() + page.name.substring(1);
    return AppBar(
      title: Text(title),
      elevation: 8,
      leading: _buildLeadingForIndex(context, page),
      actions: _buildActionsForIndex(context, ref, page),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

Widget calFilterButton(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.filter),
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) => const CalendarFilterDialog(),
      );
    },
  );
}

Widget friendSearchButton(BuildContext context, WidgetRef ref) {
  return IconButton(
    icon: Icon(Icons.search),
    onPressed: () {
      showUserSearchDialog(context, ref);
    },
  );
}
