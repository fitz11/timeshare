import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/event/event.dart';
import 'package:timeshare/ui/calendar/providers.dart';

class CopyModeIndicator extends ConsumerWidget {
  const CopyModeIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool copyMode = ref.watch(copyModeNotifierProvider);
    Event? copiedEvent = ref.watch(copyEventNotifierProvider);
    if (!copyMode) return SizedBox.shrink();
    return FilledButton(
      onPressed: () {
        ref.read(copyModeNotifierProvider.notifier).change();
        ref.read(copyEventNotifierProvider.notifier).clear();
      },
      child: Row(children: [Icon(Icons.copy), Text(copiedEvent!.name)]),
    );
  }
}
