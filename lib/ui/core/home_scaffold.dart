import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/data/providers/cal/cal_providers.dart';
import 'package:timeshare/data/providers/nav/nav_providers.dart';
import 'package:timeshare/ui/calendar/wgts/cal_drawer.dart';
import 'package:timeshare/ui/core/widgets/fab.dart';
import 'package:timeshare/ui/core/widgets/home_appbar.dart';
import 'package:timeshare/ui/core/widgets/home_navbar.dart';
import 'package:timeshare/ui/calendar/calendar_page.dart';
import 'package:timeshare/ui/friends/friends_page.dart';
import 'package:timeshare/ui/pages/profile_page.dart';

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
    final calendars = ref.watch(calendarsProvider);
    final HomePages index = ref.watch(navIndexProvider);

    return calendars.when(
      data: (data) => Scaffold(
        appBar: HomeAppBar(),
        // Only show drawer on calendar page
        drawer: index == HomePages.calendar ? const CalDrawer() : null,
        body: _buildBody(index),
        floatingActionButton: Fab(),
        bottomNavigationBar: HomeBottomBar(),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: const Text('error')),
    );
  }
}
