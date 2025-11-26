import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeshare/data/enums.dart';

part 'nav_providers.g.dart';

@riverpod
class NavIndexNotifier extends _$NavIndexNotifier {
  @override
  HomePages build() {
    return HomePages.calendar;
  }

  void updateWithInt(int newPage) => state = HomePages.values[newPage];
  void update(HomePages newPage) => state = newPage;
}
