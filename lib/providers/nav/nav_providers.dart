// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/enums.dart';

class NavIndexNotifier extends Notifier<HomePages> {
  @override
  HomePages build() {
    return HomePages.calendar;
  }

  void updateWithInt(int newPage) => state = HomePages.values[newPage];
  void update(HomePages newPage) => state = newPage;
}

final navIndexProvider = NotifierProvider<NavIndexNotifier, HomePages>(
  NavIndexNotifier.new,
);
