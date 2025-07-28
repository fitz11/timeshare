import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/ui/core/buttons/delete_event_button.dart';

///CURRENTLY UNUSED///
class ListHeader extends ConsumerWidget {
  const ListHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [DeleteButton()],
    );
  }
}
