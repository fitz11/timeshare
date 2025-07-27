import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeshare/data/event/event.dart';

part 'providers.g.dart';

@riverpod
class CopyModeNotifier extends _$CopyModeNotifier {
  @override
  bool build() {
    return false;
  }

  void change() => state = !state;
  void on() => state = true;
  void off() => state = false;
}

@riverpod
class CopyEventNotifier extends _$CopyEventNotifier {
  @override
  Event? build() {
    return null;
  }

  void setCopyEvent(Event e) => state = e.copyWith();
  void clear() => state = null;
}
