import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/providers/cal/cal_providers.dart';

class AfterTodayToggle extends ConsumerWidget {
  const AfterTodayToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool afterToday = ref.watch(afterTodayNotifierProvider);
    return CheckboxListTile(
      value: afterToday,
      onChanged:
          (val) => ref.read(afterTodayNotifierProvider.notifier).toggle(),
      title: const Text('Hide events before today'),
    );
  }
}
