// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nav_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NavIndexNotifier)
final navIndexProvider = NavIndexNotifierProvider._();

final class NavIndexNotifierProvider
    extends $NotifierProvider<NavIndexNotifier, HomePages> {
  NavIndexNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navIndexNotifierHash();

  @$internal
  @override
  NavIndexNotifier create() => NavIndexNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomePages value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomePages>(value),
    );
  }
}

String _$navIndexNotifierHash() => r'1a9972abbed180e846a81ae81f2e0ce1c8cfcb1e';

abstract class _$NavIndexNotifier extends $Notifier<HomePages> {
  HomePages build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HomePages, HomePages>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomePages, HomePages>,
              HomePages,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
