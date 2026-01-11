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
