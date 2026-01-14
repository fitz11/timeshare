// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/providers/nav/nav_providers.dart';
import 'package:timeshare/ui/core/responsive/responsive.dart';
import 'package:timeshare/ui/features/calendar/widgets/cal_drawer.dart';
import 'package:timeshare/ui/features/calendar/widgets/fab.dart';
import 'package:timeshare/ui/shell/home_appbar.dart';
import 'package:timeshare/ui/shell/home_nav_rail.dart';
import 'package:timeshare/ui/shell/home_navbar.dart';
import 'package:timeshare/ui/features/calendar/calendar_page.dart';
import 'package:timeshare/ui/features/friends/friends_page.dart';
import 'package:timeshare/ui/features/profile/profile_page.dart';

class HomeScaffold extends ConsumerWidget {
  const HomeScaffold({super.key});

  Widget _buildBody(HomePages currentIndex) {
    switch (currentIndex) {
      case HomePages.profile:
        return ProfilePage();
      case HomePages.calendar:
        return CalendarPage();
      case HomePages.friends:
        return FriendsPage();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomePages index = ref.watch(navIndexProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = getScreenSize(constraints.maxWidth);

        // Mobile layout: bottom navigation bar
        if (screenSize == ScreenSize.mobile) {
          return Scaffold(
            appBar: const HomeAppBar(),
            drawer: index == HomePages.calendar ? const CalDrawer() : null,
            body: _buildBody(index),
            floatingActionButton: const Fab(),
            bottomNavigationBar: const HomeBottomBar(),
          );
        }

        // Tablet/Desktop layout: navigation rail
        return Scaffold(
          appBar: const HomeAppBar(showMenuButton: false),
          body: Row(
            children: [
              HomeNavRail(screenSize: screenSize),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(child: _buildBody(index)),
            ],
          ),
          floatingActionButton: const Fab(),
        );
      },
    );
  }
}
