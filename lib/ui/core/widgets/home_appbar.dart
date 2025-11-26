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
  return FilledButton(
    child: Row(children: [Icon(Icons.search), Text('Search for users')]),
    onPressed: () {
      showUserSearchDialog(context, ref);
    },
  );
}
