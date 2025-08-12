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
String _$selectedCalendarsHash() => r'7c991036169a3e455630f88d9857530d711ddb0b';

/// See also [selectedCalendars].
@ProviderFor(selectedCalendars)
final selectedCalendarsProvider = AutoDisposeProvider<List<Calendar>>.internal(
  selectedCalendars,
  name: r'selectedCalendarsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedCalendarsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedCalendarsRef = AutoDisposeProviderRef<List<Calendar>>;
String _$visibleEventsMapHash() => r'fc0ae1ef6e7534779f249547aee25574b78dfd18';

/// See also [visibleEventsMap].
@ProviderFor(visibleEventsMap)
final visibleEventsMapProvider =
    AutoDisposeProvider<Map<DateTime, List<Event>>>.internal(
      visibleEventsMap,
      name: r'visibleEventsMapProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$visibleEventsMapHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VisibleEventsMapRef =
    AutoDisposeProviderRef<Map<DateTime, List<Event>>>;
String _$visibleEventsListHash() => r'54298fa97c4eac13d988a55319bca874856f40a7';

/// See also [visibleEventsList].
@ProviderFor(visibleEventsList)
final visibleEventsListProvider = AutoDisposeProvider<List<Event>>.internal(
  visibleEventsList,
  name: r'visibleEventsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$visibleEventsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VisibleEventsListRef = AutoDisposeProviderRef<List<Event>>;
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
String _$selectedCalIdsNotifierHash() =>
    r'622618cc18e27e7a1b43fd863dde915be02170d9';

/// See also [SelectedCalIdsNotifier].
@ProviderFor(SelectedCalIdsNotifier)
final selectedCalIdsNotifierProvider =
    AutoDisposeNotifierProvider<SelectedCalIdsNotifier, Set<String>>.internal(
      SelectedCalIdsNotifier.new,
      name: r'selectedCalIdsNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedCalIdsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedCalIdsNotifier = AutoDisposeNotifier<Set<String>>;
String _$selectedDayNotifierHash() =>
    r'a4fb122554393c2a3543331b789e3a18f46a5fa6';

/// See also [SelectedDayNotifier].
@ProviderFor(SelectedDayNotifier)
final selectedDayNotifierProvider =
    AutoDisposeNotifierProvider<SelectedDayNotifier, DateTime?>.internal(
      SelectedDayNotifier.new,
      name: r'selectedDayNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedDayNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedDayNotifier = AutoDisposeNotifier<DateTime?>;
String _$afterTodayNotifierHash() =>
    r'fc41b18a6526249165ee73dd8ddea3fa4ca3b295';

/// See also [AfterTodayNotifier].
@ProviderFor(AfterTodayNotifier)
final afterTodayNotifierProvider =
    AutoDisposeNotifierProvider<AfterTodayNotifier, bool>.internal(
      AfterTodayNotifier.new,
      name: r'afterTodayNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$afterTodayNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AfterTodayNotifier = AutoDisposeNotifier<bool>;
String _$copyModeNotifierHash() => r'6f2e7ef33ceb5bbbbe48364ace57d87370c88b6c';

/// See also [CopyModeNotifier].
@ProviderFor(CopyModeNotifier)
final copyModeNotifierProvider =
    AutoDisposeNotifierProvider<CopyModeNotifier, bool>.internal(
      CopyModeNotifier.new,
      name: r'copyModeNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$copyModeNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CopyModeNotifier = AutoDisposeNotifier<bool>;
String _$copyEventNotifierHash() => r'40828c298d390eafa02c65b375533c70356c0a45';

/// See also [CopyEventNotifier].
@ProviderFor(CopyEventNotifier)
final copyEventNotifierProvider =
    AutoDisposeNotifierProvider<CopyEventNotifier, Event?>.internal(
      CopyEventNotifier.new,
      name: r'copyEventNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$copyEventNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CopyEventNotifier = AutoDisposeNotifier<Event?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
