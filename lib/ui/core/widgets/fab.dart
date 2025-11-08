import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/data/providers/nav/nav_providers.dart';

class Fab extends ConsumerWidget {
  const Fab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(navIndexProvider);
    if (page != HomePages.calendar) {
      return const Placeholder();
    }
    return FloatingActionButton(
      elevation: 8,
      onPressed: () {},
      child: Icon(Icons.add),
    );
  }
}
