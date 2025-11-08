import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/providers/cal/cal_providers.dart';

class CopyModeIndicator extends ConsumerWidget {
  const CopyModeIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool copyMode = ref.watch(copyModeProvider);
    Event? copiedEvent = ref.watch(copyEventProvider);
    String str = '';
    if (copiedEvent != null) str = copiedEvent.name.trim();
    if (str.length > 10) str = str.substring(0, 9) + ('...');
    if (!copyMode) return SizedBox.shrink();
    return FilledButton(
      onPressed: () {
        ref.read(copyModeProvider.notifier).off();
        ref.invalidate(copyEventProvider);
      },
      child: Row(children: [Icon(Icons.copy), Text(str)]),
    );
  }
}
