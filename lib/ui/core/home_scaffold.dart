import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/data/providers/cal/cal_providers.dart';
import 'package:timeshare/data/providers/nav/nav_providers.dart';
import 'package:timeshare/data/providers/user/user_providers.dart';
import 'package:timeshare/data/user/app_user.dart';
import 'package:timeshare/ui/calendar/wgts/cal_drawer.dart';
import 'package:timeshare/ui/core/widgets/home_appbar.dart';
import 'package:timeshare/ui/core/widgets/home_navbar.dart';
import 'package:timeshare/ui/calendar/calendar_page.dart';
import 'package:timeshare/ui/pages/friends_page.dart';
import 'package:timeshare/ui/pages/profile_page.dart';

class HomeScaffold extends ConsumerWidget {
  const HomeScaffold({super.key});

  Widget _buildBody(
    HomePages currentIndex,
    AsyncValue<List<AppUser>> friendsAsync,
  ) {
    switch (currentIndex) {
      case HomePages.profile:
        return ProfilePage();
      case HomePages.calendar:
        return CalendarPage();
      case HomePages.friends:
        return FriendsPage(friendsAsync: friendsAsync);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initcals = ref.watch(calendarNotifierProvider);
    final HomePages index = ref.watch(navIndexNotifierProvider);
    final friendsAsync = ref.watch(userFriendsNotifierProvider);

    return initcals.when(
      data:
          (data) => Scaffold(
            appBar: HomeAppBar(),
            drawer: CalDrawer(),
            body: _buildBody(index, friendsAsync),
            bottomNavigationBar: HomeBottomBar(),
          ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: const Text('error')),
    );
  }
}
