// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

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
