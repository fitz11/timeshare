// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Friend request repository provider - uses REST API

@ProviderFor(friendRequestRepository)
final friendRequestRepositoryProvider = FriendRequestRepositoryProvider._();

/// Friend request repository provider - uses REST API

final class FriendRequestRepositoryProvider
    extends
        $FunctionalProvider<
          FriendRequestRepository,
          FriendRequestRepository,
          FriendRequestRepository
        >
    with $Provider<FriendRequestRepository> {
  /// Friend request repository provider - uses REST API
  FriendRequestRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendRequestRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendRequestRepositoryHash();

  @$internal
  @override
  $ProviderElement<FriendRequestRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FriendRequestRepository create(Ref ref) {
    return friendRequestRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FriendRequestRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FriendRequestRepository>(value),
    );
  }
}

String _$friendRequestRepositoryHash() =>
    r'35018a1cf767ba4e0aa4f2fe8f67e5b813fa84b4';

/// Stream of incoming friend requests (polling-based).

@ProviderFor(incomingFriendRequests)
final incomingFriendRequestsProvider = IncomingFriendRequestsProvider._();

/// Stream of incoming friend requests (polling-based).

final class IncomingFriendRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FriendRequest>>,
          List<FriendRequest>,
          Stream<List<FriendRequest>>
        >
    with
        $FutureModifier<List<FriendRequest>>,
        $StreamProvider<List<FriendRequest>> {
  /// Stream of incoming friend requests (polling-based).
  IncomingFriendRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomingFriendRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomingFriendRequestsHash();

  @$internal
  @override
  $StreamProviderElement<List<FriendRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FriendRequest>> create(Ref ref) {
    return incomingFriendRequests(ref);
  }
}

String _$incomingFriendRequestsHash() =>
    r'248c3d2c26672736e217013f4423235724eb6e06';

/// Future of sent friend requests.

@ProviderFor(sentFriendRequests)
final sentFriendRequestsProvider = SentFriendRequestsProvider._();

/// Future of sent friend requests.

final class SentFriendRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FriendRequest>>,
          List<FriendRequest>,
          FutureOr<List<FriendRequest>>
        >
    with
        $FutureModifier<List<FriendRequest>>,
        $FutureProvider<List<FriendRequest>> {
  /// Future of sent friend requests.
  SentFriendRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sentFriendRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sentFriendRequestsHash();

  @$internal
  @override
  $FutureProviderElement<List<FriendRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FriendRequest>> create(Ref ref) {
    return sentFriendRequests(ref);
  }
}

String _$sentFriendRequestsHash() =>
    r'9186f1330a32fdeae21d35908d81aa73920e08b5';

/// Count of pending incoming requests (for badge display).

@ProviderFor(pendingRequestCount)
final pendingRequestCountProvider = PendingRequestCountProvider._();

/// Count of pending incoming requests (for badge display).

final class PendingRequestCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Count of pending incoming requests (for badge display).
  PendingRequestCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingRequestCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingRequestCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return pendingRequestCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$pendingRequestCountHash() =>
    r'7cf3a9b81406e99fc6e0b79d5d7135e13618fec3';

/// Friend request mutations notifier.

@ProviderFor(FriendRequestNotifier)
final friendRequestProvider = FriendRequestNotifierProvider._();

/// Friend request mutations notifier.
final class FriendRequestNotifierProvider
    extends $NotifierProvider<FriendRequestNotifier, void> {
  /// Friend request mutations notifier.
  FriendRequestNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendRequestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendRequestNotifierHash();

  @$internal
  @override
  FriendRequestNotifier create() => FriendRequestNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$friendRequestNotifierHash() =>
    r'75f9d1670dcf0fafa97a6ac92703e91924e6aabc';

/// Friend request mutations notifier.

abstract class _$FriendRequestNotifier extends $Notifier<void> {
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
