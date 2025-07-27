import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/providers/wgt/nav_providers.dart';

class HomeBottomBar extends ConsumerWidget {
  const HomeBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(navIndexNotifierProvider);
    return BottomNavigationBar(
      currentIndex: page.index,
      onTap:
          (newIndex) =>
              ref.read(navIndexNotifierProvider.notifier).update(newIndex),
      items: [profileItem(), calendarItem(), friendsItem()],
    );
  }
}

BottomNavigationBarItem profileItem() {
  return BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile');
}

BottomNavigationBarItem calendarItem() {
  return BottomNavigationBarItem(
    icon: Icon(Icons.calendar_today),
    label: 'Calendar',
  );
}

BottomNavigationBarItem friendsItem() {
  return BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Friends');
}
