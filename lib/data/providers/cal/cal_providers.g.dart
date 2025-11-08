// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CalendarNotifier)
const calendarProvider = CalendarNotifierProvider._();

final class CalendarNotifierProvider
    extends $AsyncNotifierProvider<CalendarNotifier, List<Calendar>> {
  const CalendarNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarNotifierHash();

  @$internal
  @override
  CalendarNotifier create() => CalendarNotifier();
}

String _$calendarNotifierHash() => r'9aa8a0375ee16fdbd8a75dca05c86a1419f47531';

abstract class _$CalendarNotifier extends $AsyncNotifier<List<Calendar>> {
  FutureOr<List<Calendar>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Calendar>>, List<Calendar>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Calendar>>, List<Calendar>>,
              AsyncValue<List<Calendar>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SelectedCalIdsNotifier)
const selectedCalIdsProvider = SelectedCalIdsNotifierProvider._();

final class SelectedCalIdsNotifierProvider
    extends $NotifierProvider<SelectedCalIdsNotifier, Set<String>> {
  const SelectedCalIdsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCalIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCalIdsNotifierHash();

  @$internal
  @override
  SelectedCalIdsNotifier create() => SelectedCalIdsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$selectedCalIdsNotifierHash() =>
    r'd787829fad64a42c0f16c7686c186c097b5df348';

abstract class _$SelectedCalIdsNotifier extends $Notifier<Set<String>> {
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

@ProviderFor(visibleEventsMap)
const visibleEventsMapProvider = VisibleEventsMapProvider._();

final class VisibleEventsMapProvider
    extends
        $FunctionalProvider<
          Map<DateTime, List<Event>>,
          Map<DateTime, List<Event>>,
          Map<DateTime, List<Event>>
        >
    with $Provider<Map<DateTime, List<Event>>> {
  const VisibleEventsMapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visibleEventsMapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visibleEventsMapHash();

  @$internal
  @override
  $ProviderElement<Map<DateTime, List<Event>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<DateTime, List<Event>> create(Ref ref) {
    return visibleEventsMap(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<DateTime, List<Event>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<DateTime, List<Event>>>(value),
    );
  }
}

String _$visibleEventsMapHash() => r'5245106d97dd330333f1b8d7297f472965288939';

@ProviderFor(visibleEventsList)
const visibleEventsListProvider = VisibleEventsListProvider._();

final class VisibleEventsListProvider
    extends $FunctionalProvider<List<Event>, List<Event>, List<Event>>
    with $Provider<List<Event>> {
  const VisibleEventsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visibleEventsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visibleEventsListHash();

  @$internal
  @override
  $ProviderElement<List<Event>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Event> create(Ref ref) {
    return visibleEventsList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Event> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Event>>(value),
    );
  }
}

String _$visibleEventsListHash() => r'333bd211f28d747acbfcc9352608e4e48d126d30';

@ProviderFor(SelectedDayNotifier)
const selectedDayProvider = SelectedDayNotifierProvider._();

final class SelectedDayNotifierProvider
    extends $NotifierProvider<SelectedDayNotifier, DateTime?> {
  const SelectedDayNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$selectedDayNotifierHash();

  @$internal
  @override
  SelectedDayNotifier create() => SelectedDayNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$selectedDayNotifierHash() =>
    r'a4fb122554393c2a3543331b789e3a18f46a5fa6';

abstract class _$SelectedDayNotifier extends $Notifier<DateTime?> {
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

@ProviderFor(AfterTodayNotifier)
const afterTodayProvider = AfterTodayNotifierProvider._();

final class AfterTodayNotifierProvider
    extends $NotifierProvider<AfterTodayNotifier, bool> {
  const AfterTodayNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'afterTodayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$afterTodayNotifierHash();

  @$internal
  @override
  AfterTodayNotifier create() => AfterTodayNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$afterTodayNotifierHash() =>
    r'bd116d8d4d91188fe5bfbb11aa3b81c7f4aab233';

abstract class _$AfterTodayNotifier extends $Notifier<bool> {
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

@ProviderFor(CopyModeNotifier)
const copyModeProvider = CopyModeNotifierProvider._();

final class CopyModeNotifierProvider
    extends $NotifierProvider<CopyModeNotifier, bool> {
  const CopyModeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'copyModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$copyModeNotifierHash();

  @$internal
  @override
  CopyModeNotifier create() => CopyModeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$copyModeNotifierHash() => r'6f2e7ef33ceb5bbbbe48364ace57d87370c88b6c';

abstract class _$CopyModeNotifier extends $Notifier<bool> {
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

@ProviderFor(DeleteModeNotifier)
const deleteModeProvider = DeleteModeNotifierProvider._();

final class DeleteModeNotifierProvider
    extends $NotifierProvider<DeleteModeNotifier, bool> {
  const DeleteModeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteModeNotifierHash();

  @$internal
  @override
  DeleteModeNotifier create() => DeleteModeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$deleteModeNotifierHash() =>
    r'1667a9927e7c7bae0fd3ce1e6cb17cf5ceea9964';

abstract class _$DeleteModeNotifier extends $Notifier<bool> {
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

@ProviderFor(CopyEventNotifier)
const copyEventProvider = CopyEventNotifierProvider._();

final class CopyEventNotifierProvider
    extends $NotifierProvider<CopyEventNotifier, Event?> {
  const CopyEventNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'copyEventProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$copyEventNotifierHash();

  @$internal
  @override
  CopyEventNotifier create() => CopyEventNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Event? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Event?>(value),
    );
  }
}

String _$copyEventNotifierHash() => r'40828c298d390eafa02c65b375533c70356c0a45';

abstract class _$CopyEventNotifier extends $Notifier<Event?> {
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
