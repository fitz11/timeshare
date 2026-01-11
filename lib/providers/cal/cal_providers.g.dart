// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository provider

@ProviderFor(calendarRepository)
const calendarRepositoryProvider = CalendarRepositoryProvider._();

/// Repository provider

final class CalendarRepositoryProvider
    extends
        $FunctionalProvider<
          CalendarRepository,
          CalendarRepository,
          CalendarRepository
        >
    with $Provider<CalendarRepository> {
  /// Repository provider
  const CalendarRepositoryProvider._()
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
    r'2519acfcf64741b15b812076f30ba3e2840d785f';

/// Main calendar stream - automatically updates when Firestore changes
/// Keep alive to prevent re-initialization when navigating away

@ProviderFor(calendars)
const calendarsProvider = CalendarsProvider._();

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
  const CalendarsProvider._()
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
const eventsForSelectedCalendarsProvider =
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
  const EventsForSelectedCalendarsProvider._()
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

/// Calendar mutations - simplified without optimistic updates.
/// The stream will automatically update the UI when Firestore changes.

@ProviderFor(CalendarMutations)
const calendarMutationsProvider = CalendarMutationsProvider._();

/// Calendar mutations - simplified without optimistic updates.
/// The stream will automatically update the UI when Firestore changes.
final class CalendarMutationsProvider
    extends $NotifierProvider<CalendarMutations, void> {
  /// Calendar mutations - simplified without optimistic updates.
  /// The stream will automatically update the UI when Firestore changes.
  const CalendarMutationsProvider._()
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

String _$calendarMutationsHash() => r'ed25364e5f63944faa2153853cbb944eae74fd00';

/// Calendar mutations - simplified without optimistic updates.
/// The stream will automatically update the UI when Firestore changes.

abstract class _$CalendarMutations extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

/// Selected calendar IDs - which calendars are visible
/// Synchronous projection from calendars stream - no async overhead.

@ProviderFor(SelectedCalendarIds)
const selectedCalendarIdsProvider = SelectedCalendarIdsProvider._();

/// Selected calendar IDs - which calendars are visible
/// Synchronous projection from calendars stream - no async overhead.
final class SelectedCalendarIdsProvider
    extends $NotifierProvider<SelectedCalendarIds, Set<String>> {
  /// Selected calendar IDs - which calendars are visible
  /// Synchronous projection from calendars stream - no async overhead.
  const SelectedCalendarIdsProvider._()
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
    r'c4b321e6c9c062be51d57a4f67bc56987514c576';

/// Selected calendar IDs - which calendars are visible
/// Synchronous projection from calendars stream - no async overhead.

abstract class _$SelectedCalendarIds extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Selected day in the calendar

@ProviderFor(SelectedDay)
const selectedDayProvider = SelectedDayProvider._();

/// Selected day in the calendar
final class SelectedDayProvider
    extends $NotifierProvider<SelectedDay, DateTime?> {
  /// Selected day in the calendar
  const SelectedDayProvider._()
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
    final created = build();
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Filter toggle - show only events after today

@ProviderFor(AfterTodayFilter)
const afterTodayFilterProvider = AfterTodayFilterProvider._();

/// Filter toggle - show only events after today
final class AfterTodayFilterProvider
    extends $NotifierProvider<AfterTodayFilter, bool> {
  /// Filter toggle - show only events after today
  const AfterTodayFilterProvider._()
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
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Interaction mode (normal, copy, delete)

@ProviderFor(InteractionModeState)
const interactionModeStateProvider = InteractionModeStateProvider._();

/// Interaction mode (normal, copy, delete)
final class InteractionModeStateProvider
    extends $NotifierProvider<InteractionModeState, InteractionMode> {
  /// Interaction mode (normal, copy, delete)
  const InteractionModeStateProvider._()
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
    final created = build();
    final ref = this.ref as $Ref<InteractionMode, InteractionMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InteractionMode, InteractionMode>,
              InteractionMode,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Event being copied (when in copy mode)

@ProviderFor(CopyEventState)
const copyEventStateProvider = CopyEventStateProvider._();

/// Event being copied (when in copy mode)
final class CopyEventStateProvider
    extends $NotifierProvider<CopyEventState, Event?> {
  /// Event being copied (when in copy mode)
  const CopyEventStateProvider._()
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
    final created = build();
    final ref = this.ref as $Ref<Event?, Event?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Event?, Event?>,
              Event?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Expanded events map - memoized recurrence expansion.
/// Only recomputes when events actually change, not on filter/day changes.

@ProviderFor(expandedEventsMap)
const expandedEventsMapProvider = ExpandedEventsMapProvider._();

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
  const ExpandedEventsMapProvider._()
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

String _$expandedEventsMapHash() => r'31305d4945baf5b03a3a9577f4e1b638a855f9be';

/// Consolidated visible events - uses memoized expanded map.
/// Filtering is O(n), not O(n × 365) on day/filter changes.

@ProviderFor(visibleEvents)
const visibleEventsProvider = VisibleEventsProvider._();

/// Consolidated visible events - uses memoized expanded map.
/// Filtering is O(n), not O(n × 365) on day/filter changes.

final class VisibleEventsProvider
    extends $FunctionalProvider<VisibleEvents, VisibleEvents, VisibleEvents>
    with $Provider<VisibleEvents> {
  /// Consolidated visible events - uses memoized expanded map.
  /// Filtering is O(n), not O(n × 365) on day/filter changes.
  const VisibleEventsProvider._()
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
