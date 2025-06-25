import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/providers.dart';

class FriendsPage extends ConsumerWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(userFriendsProvider);

    return friendsAsync.when(
      data:
          (friends) => ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return ListTile(
                title: Text(friend.displayName),
                subtitle: Text(friend.email),
              );
            },
          ),
      loading:
          () => Center(
            child: SizedBox.fromSize(
              size: Size(30, 30),
              child: CircularProgressIndicator(),
            ),
          ),
      error: (e, _) => Center(child: Text('error: $e')),
    );
  }
}
