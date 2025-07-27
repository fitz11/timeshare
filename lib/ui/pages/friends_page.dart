import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/providers/user_providers.dart';
import 'package:timeshare/ui/widgets/share_calendar_dialog.dart';

class FriendsPage extends ConsumerWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('building Friend page');
    final friendsAsync = ref.watch(userFriendsNotifierProvider);

    return friendsAsync.when(
      data:
          (friends) => ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return ListTile(
                title: Text(friend.displayName),
                subtitle: Text(friend.email),
                trailing: IconButton(
                  onPressed: () {
                    showShareCalendarDialog(context, ref, friend);
                  },
                  icon: Icon(Icons.share),
                ),
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
