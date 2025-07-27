import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/data/providers/cal_providers.dart';
import 'package:timeshare/data/providers/wgt/nav_providers.dart';
import 'package:timeshare/ui/calendar/wgts/cal_drawer.dart';
import 'package:timeshare/ui/core/widgets/home_appbar.dart';
import 'package:timeshare/ui/core/widgets/home_navbar.dart';
import 'package:timeshare/ui/calendar/calendar_page.dart';
import 'package:timeshare/ui/pages/friends_page.dart';
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
    final initcals = ref.watch(calendarNotifierProvider);
    final HomePages index = ref.watch(navIndexNotifierProvider);

    return initcals.when(
      data:
          (data) => Scaffold(
            appBar: HomeAppBar(),
            drawer: CalDrawer(),
            body: _buildBody(index),
            bottomNavigationBar: HomeBottomBar(),
          ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: const Text('error')),
    );
  }
}
