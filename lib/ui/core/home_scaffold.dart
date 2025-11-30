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
import 'package:timeshare/ui/calendar/wgts/cal_drawer.dart';
import 'package:timeshare/ui/calendar/wgts/fab.dart';
import 'package:timeshare/ui/core/widgets/home_appbar.dart';
import 'package:timeshare/ui/core/widgets/home_navbar.dart';
import 'package:timeshare/ui/calendar/calendar_page.dart';
import 'package:timeshare/ui/friends/friends_page.dart';
import 'package:timeshare/ui/profile/profile_page.dart';

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
    // Providers are already initialized in AuthGate, just watch them here
    final HomePages index = ref.watch(navIndexProvider);

    return Scaffold(
      appBar: HomeAppBar(),
      // Only show drawer on calendar page
      drawer: index == HomePages.calendar ? const CalDrawer() : null,
      body: _buildBody(index),
      floatingActionButton: Fab(),
      bottomNavigationBar: HomeBottomBar(),
    );
  }
}
