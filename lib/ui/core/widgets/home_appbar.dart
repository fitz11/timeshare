// Timeshare: a cross-platform app to make and share calendars.
// Copyright (C) 2025  David Fitzsimmons
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/providers/nav/nav_providers.dart';
import 'package:timeshare/ui/calendar/wgts/calendar_filter_sheet.dart';
import 'package:timeshare/ui/core/buttons/open_drawer_button.dart';
import 'package:timeshare/ui/dialogs/user_search_dialog.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

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
    switch (page) {
      case HomePages.calendar:
        return OpenDrawerButton();
      default:
        return SizedBox();
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
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => const CalendarFilterSheet(),
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
