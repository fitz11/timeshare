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
import 'package:timeshare/data/enums.dart';

// DEPRECATED
class CopyModeIndicator extends ConsumerWidget {
  const CopyModeIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(interactionModeStateProvider);
    final copiedEvent = ref.watch(copyEventStateProvider);

    if (mode != InteractionMode.copy) return const SizedBox.shrink();

    String str = '';
    if (copiedEvent != null) str = copiedEvent.name.trim();
    if (str.length > 10) str = str.substring(0, 9) + ('...');

    return FilledButton(
      onPressed: () {
        ref.read(interactionModeStateProvider.notifier).setNormal();
        ref.read(copyEventStateProvider.notifier).clear();
      },
      child: Row(children: [Icon(Icons.copy), Text(str)]),
    );
  }
}
