// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sel_cal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$visibleEventsMapHash() => r'04c6e6f88967413f79021d4cdab8212b98329f38';

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
String _$visibleEventsListHash() => r'ea63285e25c874e8824169771920fdfabfef10ef';

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
String _$selectedDayHash() => r'14b922b997135429fc8975785356aebcef1aa0c5';

/// See also [selectedDay].
@ProviderFor(selectedDay)
final selectedDayProvider = AutoDisposeProvider<DateTime>.internal(
  selectedDay,
  name: r'selectedDayProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedDayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedDayRef = AutoDisposeProviderRef<DateTime>;
String _$eventsForSelectedDayHash() =>
    r'f82fb2238e9840e7f763796f97cc843d6f0a4c89';

/// See also [eventsForSelectedDay].
@ProviderFor(eventsForSelectedDay)
final eventsForSelectedDayProvider = AutoDisposeProvider<List<Event>>.internal(
  eventsForSelectedDay,
  name: r'eventsForSelectedDayProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$eventsForSelectedDayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventsForSelectedDayRef = AutoDisposeProviderRef<List<Event>>;
String _$selectedCalendarsNotifierHash() =>
    r'b973656cf035f8fbf4f5f8d3d4b906d52518af97';

/// See also [SelectedCalendarsNotifier].
@ProviderFor(SelectedCalendarsNotifier)
final selectedCalendarsNotifierProvider = AutoDisposeNotifierProvider<
  SelectedCalendarsNotifier,
  Set<String>
>.internal(
  SelectedCalendarsNotifier.new,
  name: r'selectedCalendarsNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedCalendarsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCalendarsNotifier = AutoDisposeNotifier<Set<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
