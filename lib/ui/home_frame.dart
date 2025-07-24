import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/providers/providers.dart';
import 'package:timeshare/ui/pages/calendarpage.dart';
import 'package:timeshare/ui/pages/friends_page.dart';
import 'package:timeshare/ui/pages/profile_page.dart';
import 'package:timeshare/ui/widgets/calendar_filter_sheet.dart';
import 'package:timeshare/ui/widgets/user_search_dialog.dart';

class HomeFrame extends ConsumerStatefulWidget {
  const HomeFrame({super.key});

  @override
  ConsumerState<HomeFrame> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeFrame> {
  @override
  void initState() {
    super.initState();
    print('Init called for Homepage');
  }

  ///builds app bar actions based on state
  List<Widget> _buildActionsForIndex(int index) {
    //switch to support more actions as needed
    switch (index) {
      case 1:
        return [
          IconButton(
            icon: Icon(Icons.filter),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => const CalendarFilterSheet(),
              );
            },
          ),
        ];
      case 2:
        return [
          FilledButton(
            child: Row(
              children: [Icon(Icons.search), Text('Search for users')],
            ),
            onPressed: () {
              showUserSearchDialog(context, ref);
            },
          ),
        ];
      default:
        return [];
    }
  }

  Widget _buildBody(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return ProfilePage();
      case 1:
        return CalendarPage();
      case 2:
        return FriendsPage();
      default:
        return CalendarPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(bottomNavIndexProvider);
    final pageTitles = ['Profile', 'Calendar', 'Friends'];

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[index]),
        actions: _buildActionsForIndex(index),
      ),

      body: _buildBody(index),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap:
            (newIndex) =>
                ref.read(bottomNavIndexProvider.notifier).state = newIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Friends'),
        ],
      ),
    );
  }
}
