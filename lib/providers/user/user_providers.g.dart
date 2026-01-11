// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userRepository)
const userRepositoryProvider = UserRepositoryProvider._();

final class UserRepositoryProvider
    extends $FunctionalProvider<UserRepository, UserRepository, UserRepository>
    with $Provider<UserRepository> {
  const UserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserRepository create(Ref ref) {
    return userRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRepository>(value),
    );
  }
}

String _$userRepositoryHash() => r'4c619c79cd9396d77d37b47f881dc894ec558431';

@ProviderFor(UserFriendsNotifier)
const userFriendsProvider = UserFriendsNotifierProvider._();

final class UserFriendsNotifierProvider
    extends $AsyncNotifierProvider<UserFriendsNotifier, List<AppUser>> {
  const UserFriendsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userFriendsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userFriendsNotifierHash();

  @$internal
  @override
  UserFriendsNotifier create() => UserFriendsNotifier();
}

String _$userFriendsNotifierHash() =>
    r'9ff1dff7d3f4da2f007fdab67678e6b994aebd02';

abstract class _$UserFriendsNotifier extends $AsyncNotifier<List<AppUser>> {
  FutureOr<List<AppUser>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<AppUser>>, List<AppUser>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AppUser>>, List<AppUser>>,
              AsyncValue<List<AppUser>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(userSearch)
const userSearchProvider = UserSearchFamily._();

final class UserSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppUser>>,
          List<AppUser>,
          FutureOr<List<AppUser>>
        >
    with $FutureModifier<List<AppUser>>, $FutureProvider<List<AppUser>> {
  const UserSearchProvider._({
    required UserSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userSearchHash();

  @override
  String toString() {
    return r'userSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AppUser>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppUser>> create(Ref ref) {
    final argument = this.argument as String;
    return userSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userSearchHash() => r'cc3e6d3bcb75a33440f5edc7a2437439b5f4be85';

final class UserSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AppUser>>, String> {
  const UserSearchFamily._()
    : super(
        retry: null,
        name: r'userSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserSearchProvider call(String email) =>
      UserSearchProvider._(argument: email, from: this);

  @override
  String toString() => r'userSearchProvider';
}

@ProviderFor(CurrentUserNotifier)
const currentUserProvider = CurrentUserNotifierProvider._();

final class CurrentUserNotifierProvider
    extends $AsyncNotifierProvider<CurrentUserNotifier, AppUser?> {
  const CurrentUserNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserNotifierHash();

  @$internal
  @override
  CurrentUserNotifier create() => CurrentUserNotifier();
}

String _$currentUserNotifierHash() =>
    r'effdb2c300eeed96aa46651c43249dd2ff8eeb63';

abstract class _$CurrentUserNotifier extends $AsyncNotifier<AppUser?> {
  FutureOr<AppUser?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AppUser?>, AppUser?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppUser?>, AppUser?>,
              AsyncValue<AppUser?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
