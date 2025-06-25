import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers.dart';
import 'package:timeshare/ui/pages/calendarview.dart';
import 'package:timeshare/ui/pages/friends_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  List<Widget> _buildActionsForIndex(int index) {
    return [];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);
    final pageTitles = ['Profile', 'Calendar', 'Friends'];
    final pages = [ProfileScreen(), CalendarView(), FriendsPage()];

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[index]),
        actions: _buildActionsForIndex(index),
      ),

      body: IndexedStack(index: index, children: pages),

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
