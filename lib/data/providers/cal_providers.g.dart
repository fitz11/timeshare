// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$calendarRepositoryHash() =>
    r'822cb81867829df105b4a163f38de794b87f8122';

/// See also [calendarRepository].
@ProviderFor(calendarRepository)
final calendarRepositoryProvider =
    AutoDisposeProvider<CalendarRepository>.internal(
      calendarRepository,
      name: r'calendarRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$calendarRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CalendarRepositoryRef = AutoDisposeProviderRef<CalendarRepository>;
String _$calendarNotifierHash() => r'caab2f6e1791b536b55b20a41d466fea8fc0f2e6';

/// See also [CalendarNotifier].
@ProviderFor(CalendarNotifier)
final calendarNotifierProvider =
    AsyncNotifierProvider<CalendarNotifier, List<Calendar>>.internal(
      CalendarNotifier.new,
      name: r'calendarNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$calendarNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CalendarNotifier = AsyncNotifier<List<Calendar>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
