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
import 'package:timeshare/providers/cal/cal_providers.dart';

class AfterTodayToggle extends ConsumerWidget {
  const AfterTodayToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool afterToday = ref.watch(afterTodayFilterProvider);
    return SwitchListTile(
      secondary: const Icon(Icons.filter_alt_outlined),
      value: afterToday,
      onChanged: (val) => ref.read(afterTodayFilterProvider.notifier).set(val),
      title: const Text('Hide past events'),
      subtitle: const Text('Show only upcoming events'),
    );
  }
}
