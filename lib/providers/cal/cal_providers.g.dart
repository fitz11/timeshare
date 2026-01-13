// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AppLogger provider - enables DI and easier testing

@ProviderFor(appLogger)
final appLoggerProvider = AppLoggerProvider._();

/// AppLogger provider - enables DI and easier testing

final class AppLoggerProvider
    extends $FunctionalProvider<AppLogger, AppLogger, AppLogger>
    with $Provider<AppLogger> {
  /// AppLogger provider - enables DI and easier testing
  AppLoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLoggerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLoggerHash();

  @$internal
  @override
  $ProviderElement<AppLogger> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppLogger create(Ref ref) {
    return appLogger(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLogger value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLogger>(value),
    );
  }
}

String _$appLoggerHash() => r'df8d663b25029b9f0a06806ba7ff51cc86d2ed83';

/// Repository provider with logging wrapper - uses REST API

@ProviderFor(calendarRepository)
final calendarRepositoryProvider = CalendarRepositoryProvider._();

/// Repository provider with logging wrapper - uses REST API

final class CalendarRepositoryProvider
    extends
        $FunctionalProvider<
          CalendarRepository,
          CalendarRepository,
          CalendarRepository
        >
    with $Provider<CalendarRepository> {
  /// Repository provider with logging wrapper - uses REST API
  CalendarRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarRepositoryHash();

  @$internal
  @override
  $ProviderElement<CalendarRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CalendarRepository create(Ref ref) {
    return calendarRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalendarRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalendarRepository>(value),
    );
  }
}

String _$calendarRepositoryHash() =>
    r'd46b3d0dbb983e97b83ebeb1949f15dea956f10e';

/// Main calendar stream - automatically updates when Firestore changes
/// Keep alive to prevent re-initialization when navigating away

@ProviderFor(calendars)
final calendarsProvider = CalendarsProvider._();

/// Main calendar stream - automatically updates when Firestore changes
/// Keep alive to prevent re-initialization when navigating away

final class CalendarsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Calendar>>,
          List<Calendar>,
          Stream<List<Calendar>>
        >
    with $FutureModifier<List<Calendar>>, $StreamProvider<List<Calendar>> {
  /// Main calendar stream - automatically updates when Firestore changes
  /// Keep alive to prevent re-initialization when navigating away
  CalendarsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarsHash();

  @$internal
  @override
  $StreamProviderElement<List<Calendar>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Calendar>> create(Ref ref) {
    return calendars(ref);
  }
}

String _$calendarsHash() => r'4e532657317293ffabbd52d135a67b1443d8b0fb';

/// Events stream for selected calendars

@ProviderFor(eventsForSelectedCalendars)
final eventsForSelectedCalendarsProvider =
    EventsForSelectedCalendarsProvider._();

/// Events stream for selected calendars

final class EventsForSelectedCalendarsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Event>>,
          List<Event>,
          Stream<List<Event>>
        >
    with $FutureModifier<List<Event>>, $StreamProvider<List<Event>> {
  /// Events stream for selected calendars
  EventsForSelectedCalendarsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventsForSelectedCalendarsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventsForSelectedCalendarsHash();

  @$internal
  @override
  $StreamProviderElement<List<Event>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Event>> create(Ref ref) {
    return eventsForSelectedCalendars(ref);
  }
}

String _$eventsForSelectedCalendarsHash() =>
    r'6b8a7da79d1f54f8550761aba2091e0845c6c0f5';

/// Calendar mutations with optimistic update support.
/// Includes conflict detection and retry mechanisms for concurrent edit handling.

@ProviderFor(CalendarMutations)
final calendarMutationsProvider = CalendarMutationsProvider._();

/// Calendar mutations with optimistic update support.
/// Includes conflict detection and retry mechanisms for concurrent edit handling.
final class CalendarMutationsProvider
    extends $NotifierProvider<CalendarMutations, void> {
  /// Calendar mutations with optimistic update support.
  /// Includes conflict detection and retry mechanisms for concurrent edit handling.
  CalendarMutationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarMutationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarMutationsHash();

  @$internal
  @override
  CalendarMutations create() => CalendarMutations();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$calendarMutationsHash() => r'e1c0ac8a7c563591972c82416b919584aee116ce';

/// Calendar mutations with optimistic update support.
/// Includes conflict detection and retry mechanisms for concurrent edit handling.

abstract class _$CalendarMutations extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Selected calendar IDs - which calendars are visible
/// Synchronous projection from calendars stream - no async overhead.

@ProviderFor(SelectedCalendarIds)
final selectedCalendarIdsProvider = SelectedCalendarIdsProvider._();

/// Selected calendar IDs - which calendars are visible
/// Synchronous projection from calendars stream - no async overhead.
final class SelectedCalendarIdsProvider
    extends $NotifierProvider<SelectedCalendarIds, Set<String>> {
  /// Selected calendar IDs - which calendars are visible
  /// Synchronous projection from calendars stream - no async overhead.
  SelectedCalendarIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCalendarIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCalendarIdsHash();

  @$internal
  @override
  SelectedCalendarIds create() => SelectedCalendarIds();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$selectedCalendarIdsHash() =>
    r'310986f92a1d76791e7c2bd023383910506d12ad';

/// Selected calendar IDs - which calendars are visible
/// Synchronous projection from calendars stream - no async overhead.

abstract class _$SelectedCalendarIds extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Selected day in the calendar

@ProviderFor(SelectedDay)
final selectedDayProvider = SelectedDayProvider._();

/// Selected day in the calendar
final class SelectedDayProvider
    extends $NotifierProvider<SelectedDay, DateTime?> {
  /// Selected day in the calendar
  SelectedDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDayHash();

  @$internal
  @override
  SelectedDay create() => SelectedDay();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$selectedDayHash() => r'ede8b179013d72ab750b0380daf7619a86d48ef2';

/// Selected day in the calendar

abstract class _$SelectedDay extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Focused day in the calendar widget (which month is displayed)

@ProviderFor(FocusedDay)
final focusedDayProvider = FocusedDayProvider._();

/// Focused day in the calendar widget (which month is displayed)
final class FocusedDayProvider extends $NotifierProvider<FocusedDay, DateTime> {
  /// Focused day in the calendar widget (which month is displayed)
  FocusedDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'focusedDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$focusedDayHash();

  @$internal
  @override
  FocusedDay create() => FocusedDay();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$focusedDayHash() => r'e1ebbe60b4d3618dfdb9ee27339eb7a15d198f0f';

/// Focused day in the calendar widget (which month is displayed)

abstract class _$FocusedDay extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Calendar display format (month, two weeks, week)

@ProviderFor(CalendarFormatState)
final calendarFormatStateProvider = CalendarFormatStateProvider._();

/// Calendar display format (month, two weeks, week)
final class CalendarFormatStateProvider
    extends $NotifierProvider<CalendarFormatState, CalendarFormat> {
  /// Calendar display format (month, two weeks, week)
  CalendarFormatStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarFormatStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarFormatStateHash();

  @$internal
  @override
  CalendarFormatState create() => CalendarFormatState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalendarFormat value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalendarFormat>(value),
    );
  }
}

String _$calendarFormatStateHash() =>
    r'5ed300ae3eb9e1ab764e0968b1c485ffecc3d2c2';

/// Calendar display format (month, two weeks, week)

abstract class _$CalendarFormatState extends $Notifier<CalendarFormat> {
  CalendarFormat build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CalendarFormat, CalendarFormat>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CalendarFormat, CalendarFormat>,
              CalendarFormat,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Filter toggle - show only events after today

@ProviderFor(AfterTodayFilter)
final afterTodayFilterProvider = AfterTodayFilterProvider._();

/// Filter toggle - show only events after today
final class AfterTodayFilterProvider
    extends $NotifierProvider<AfterTodayFilter, bool> {
  /// Filter toggle - show only events after today
  AfterTodayFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'afterTodayFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$afterTodayFilterHash();

  @$internal
  @override
  AfterTodayFilter create() => AfterTodayFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$afterTodayFilterHash() => r'a1e9f1a53df4ed20f2898530b5b127cc0ecc4c70';

/// Filter toggle - show only events after today

abstract class _$AfterTodayFilter extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Interaction mode (normal, copy, delete)

@ProviderFor(InteractionModeState)
final interactionModeStateProvider = InteractionModeStateProvider._();

/// Interaction mode (normal, copy, delete)
final class InteractionModeStateProvider
    extends $NotifierProvider<InteractionModeState, InteractionMode> {
  /// Interaction mode (normal, copy, delete)
  InteractionModeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interactionModeStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interactionModeStateHash();

  @$internal
  @override
  InteractionModeState create() => InteractionModeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InteractionMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InteractionMode>(value),
    );
  }
}

String _$interactionModeStateHash() =>
    r'de69aa2fca074a42fd407773ae4e05a61fecd1be';

/// Interaction mode (normal, copy, delete)

abstract class _$InteractionModeState extends $Notifier<InteractionMode> {
  InteractionMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<InteractionMode, InteractionMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InteractionMode, InteractionMode>,
              InteractionMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Event being copied (when in copy mode)

@ProviderFor(CopyEventState)
final copyEventStateProvider = CopyEventStateProvider._();

/// Event being copied (when in copy mode)
final class CopyEventStateProvider
    extends $NotifierProvider<CopyEventState, Event?> {
  /// Event being copied (when in copy mode)
  CopyEventStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'copyEventStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$copyEventStateHash();

  @$internal
  @override
  CopyEventState create() => CopyEventState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Event? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Event?>(value),
    );
  }
}

String _$copyEventStateHash() => r'3c98b1d100de285a00222149dc03b4b34a81926d';

/// Event being copied (when in copy mode)

abstract class _$CopyEventState extends $Notifier<Event?> {
  Event? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Event?, Event?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Event?, Event?>,
              Event?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Expanded events map - memoized recurrence expansion.
/// Only recomputes when events actually change, not on filter/day changes.

@ProviderFor(expandedEventsMap)
final expandedEventsMapProvider = ExpandedEventsMapProvider._();

/// Expanded events map - memoized recurrence expansion.
/// Only recomputes when events actually change, not on filter/day changes.

final class ExpandedEventsMapProvider
    extends
        $FunctionalProvider<
          Map<DateTime, List<Event>>,
          Map<DateTime, List<Event>>,
          Map<DateTime, List<Event>>
        >
    with $Provider<Map<DateTime, List<Event>>> {
  /// Expanded events map - memoized recurrence expansion.
  /// Only recomputes when events actually change, not on filter/day changes.
  ExpandedEventsMapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expandedEventsMapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expandedEventsMapHash();

  @$internal
  @override
  $ProviderElement<Map<DateTime, List<Event>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<DateTime, List<Event>> create(Ref ref) {
    return expandedEventsMap(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<DateTime, List<Event>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<DateTime, List<Event>>>(value),
    );
  }
}

String _$expandedEventsMapHash() => r'82f6297bbdcfa5f8f070d05b92071a21a290be6a';

/// Consolidated visible events - uses memoized expanded map.
/// Filtering is O(n), not O(n × 365) on day/filter changes.

@ProviderFor(visibleEvents)
final visibleEventsProvider = VisibleEventsProvider._();

/// Consolidated visible events - uses memoized expanded map.
/// Filtering is O(n), not O(n × 365) on day/filter changes.

final class VisibleEventsProvider
    extends $FunctionalProvider<VisibleEvents, VisibleEvents, VisibleEvents>
    with $Provider<VisibleEvents> {
  /// Consolidated visible events - uses memoized expanded map.
  /// Filtering is O(n), not O(n × 365) on day/filter changes.
  VisibleEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visibleEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visibleEventsHash();

  @$internal
  @override
  $ProviderElement<VisibleEvents> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VisibleEvents create(Ref ref) {
    return visibleEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VisibleEvents value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VisibleEvents>(value),
    );
  }
}

String _$visibleEventsHash() => r'91013c1b4e7cfc57174098b3c0efc0fc25af233c';

/// Calendar name lookup by ID - prevents full calendar list watches in EventListItem.
/// Uses family modifier so each calendar ID gets its own cached provider instance.

@ProviderFor(calendarName)
final calendarNameProvider = CalendarNameFamily._();

/// Calendar name lookup by ID - prevents full calendar list watches in EventListItem.
/// Uses family modifier so each calendar ID gets its own cached provider instance.

final class CalendarNameProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Calendar name lookup by ID - prevents full calendar list watches in EventListItem.
  /// Uses family modifier so each calendar ID gets its own cached provider instance.
  CalendarNameProvider._({
    required CalendarNameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'calendarNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$calendarNameHash();

  @override
  String toString() {
    return r'calendarNameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as String;
    return calendarName(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$calendarNameHash() => r'411142b8af2ce64575ce21228365be4e52173117';

/// Calendar name lookup by ID - prevents full calendar list watches in EventListItem.
/// Uses family modifier so each calendar ID gets its own cached provider instance.

final class CalendarNameFamily extends $Family
    with $FunctionalFamilyOverride<String, String> {
  CalendarNameFamily._()
    : super(
        retry: null,
        name: r'calendarNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Calendar name lookup by ID - prevents full calendar list watches in EventListItem.
  /// Uses family modifier so each calendar ID gets its own cached provider instance.

  CalendarNameProvider call(String calendarId) =>
      CalendarNameProvider._(argument: calendarId, from: this);

  @override
  String toString() => r'calendarNameProvider';
}

/// Map of calendar IDs to names - for efficient bulk lookups in lists.

@ProviderFor(calendarNamesMap)
final calendarNamesMapProvider = CalendarNamesMapProvider._();

/// Map of calendar IDs to names - for efficient bulk lookups in lists.

final class CalendarNamesMapProvider
    extends
        $FunctionalProvider<
          Map<String, String>,
          Map<String, String>,
          Map<String, String>
        >
    with $Provider<Map<String, String>> {
  /// Map of calendar IDs to names - for efficient bulk lookups in lists.
  CalendarNamesMapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarNamesMapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarNamesMapHash();

  @$internal
  @override
  $ProviderElement<Map<String, String>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, String> create(Ref ref) {
    return calendarNamesMap(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, String>>(value),
    );
  }
}

String _$calendarNamesMapHash() => r'8837dec100b81a2f22d478b7a42c138ced7f5811';
