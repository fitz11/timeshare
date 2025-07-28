// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sel_cal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
String _$visibleEventsListHash() => r'5c02341187d2dcb0d7da0eed83e7e4eea4b7db1c';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
