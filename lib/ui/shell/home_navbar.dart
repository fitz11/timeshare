// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers/nav/nav_providers.dart';

class HomeBottomBar extends ConsumerWidget {
  const HomeBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(navIndexProvider);
    return BottomNavigationBar(
      currentIndex: page.index,
      onTap: (newIndex) =>
          ref.read(navIndexProvider.notifier).updateWithInt(newIndex),
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
  return BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Friends');
}
