// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ownership_transfer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Ownership transfer repository provider - uses REST API

@ProviderFor(ownershipTransferRepository)
final ownershipTransferRepositoryProvider =
    OwnershipTransferRepositoryProvider._();

/// Ownership transfer repository provider - uses REST API

final class OwnershipTransferRepositoryProvider
    extends
        $FunctionalProvider<
          OwnershipTransferRepository,
          OwnershipTransferRepository,
          OwnershipTransferRepository
        >
    with $Provider<OwnershipTransferRepository> {
  /// Ownership transfer repository provider - uses REST API
  OwnershipTransferRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownershipTransferRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownershipTransferRepositoryHash();

  @$internal
  @override
  $ProviderElement<OwnershipTransferRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OwnershipTransferRepository create(Ref ref) {
    return ownershipTransferRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OwnershipTransferRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OwnershipTransferRepository>(value),
    );
  }
}

String _$ownershipTransferRepositoryHash() =>
    r'3a4efdd56b0c658dc8c3bdc0dc53d180c3eb6cbf';

/// Stream of incoming ownership transfer requests (polling-based).

@ProviderFor(incomingOwnershipTransfers)
final incomingOwnershipTransfersProvider =
    IncomingOwnershipTransfersProvider._();

/// Stream of incoming ownership transfer requests (polling-based).

final class IncomingOwnershipTransfersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OwnershipTransferRequest>>,
          List<OwnershipTransferRequest>,
          Stream<List<OwnershipTransferRequest>>
        >
    with
        $FutureModifier<List<OwnershipTransferRequest>>,
        $StreamProvider<List<OwnershipTransferRequest>> {
  /// Stream of incoming ownership transfer requests (polling-based).
  IncomingOwnershipTransfersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomingOwnershipTransfersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomingOwnershipTransfersHash();

  @$internal
  @override
  $StreamProviderElement<List<OwnershipTransferRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<OwnershipTransferRequest>> create(Ref ref) {
    return incomingOwnershipTransfers(ref);
  }
}

String _$incomingOwnershipTransfersHash() =>
    r'c17b2ebeb8f1088c70c77cfcb3fbcf04c105bb1a';

/// Future of sent ownership transfer requests.

@ProviderFor(sentOwnershipTransfers)
final sentOwnershipTransfersProvider = SentOwnershipTransfersProvider._();

/// Future of sent ownership transfer requests.

final class SentOwnershipTransfersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OwnershipTransferRequest>>,
          List<OwnershipTransferRequest>,
          FutureOr<List<OwnershipTransferRequest>>
        >
    with
        $FutureModifier<List<OwnershipTransferRequest>>,
        $FutureProvider<List<OwnershipTransferRequest>> {
  /// Future of sent ownership transfer requests.
  SentOwnershipTransfersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sentOwnershipTransfersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sentOwnershipTransfersHash();

  @$internal
  @override
  $FutureProviderElement<List<OwnershipTransferRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OwnershipTransferRequest>> create(Ref ref) {
    return sentOwnershipTransfers(ref);
  }
}

String _$sentOwnershipTransfersHash() =>
    r'50a29566d87af0b042cde4438a0e6c254caa3f3e';

/// Count of pending incoming transfer requests (for badge display).

@ProviderFor(pendingTransferCount)
final pendingTransferCountProvider = PendingTransferCountProvider._();

/// Count of pending incoming transfer requests (for badge display).

final class PendingTransferCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Count of pending incoming transfer requests (for badge display).
  PendingTransferCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingTransferCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingTransferCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return pendingTransferCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$pendingTransferCountHash() =>
    r'21e6e265cd5f7663b961700d862a1d4e79b0258d';

/// Ownership transfer mutations notifier.

@ProviderFor(OwnershipTransferNotifier)
final ownershipTransferProvider = OwnershipTransferNotifierProvider._();

/// Ownership transfer mutations notifier.
final class OwnershipTransferNotifierProvider
    extends $NotifierProvider<OwnershipTransferNotifier, void> {
  /// Ownership transfer mutations notifier.
  OwnershipTransferNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownershipTransferProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownershipTransferNotifierHash();

  @$internal
  @override
  OwnershipTransferNotifier create() => OwnershipTransferNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$ownershipTransferNotifierHash() =>
    r'71be749798db6827b9f831df6089e6476a6dd6f0';

/// Ownership transfer mutations notifier.

abstract class _$OwnershipTransferNotifier extends $Notifier<void> {
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
