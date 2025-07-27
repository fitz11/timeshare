// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'9cf2539fe55ff2d204d934b42bc6e6587118259c';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = AutoDisposeProvider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRepositoryRef = AutoDisposeProviderRef<UserRepository>;
String _$currentUserHash() => r'0ae7ecb805b8535e024dc917967f7c67697e6bd8';

/// See also [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeFutureProvider<AppUser?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeFutureProviderRef<AppUser?>;
String _$userSearchHash() => r'cc3e6d3bcb75a33440f5edc7a2437439b5f4be85';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userSearch].
@ProviderFor(userSearch)
const userSearchProvider = UserSearchFamily();

/// See also [userSearch].
class UserSearchFamily extends Family<AsyncValue<List<AppUser>>> {
  /// See also [userSearch].
  const UserSearchFamily();

  /// See also [userSearch].
  UserSearchProvider call(String email) {
    return UserSearchProvider(email);
  }

  @override
  UserSearchProvider getProviderOverride(
    covariant UserSearchProvider provider,
  ) {
    return call(provider.email);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userSearchProvider';
}

/// See also [userSearch].
class UserSearchProvider extends AutoDisposeFutureProvider<List<AppUser>> {
  /// See also [userSearch].
  UserSearchProvider(String email)
    : this._internal(
        (ref) => userSearch(ref as UserSearchRef, email),
        from: userSearchProvider,
        name: r'userSearchProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$userSearchHash,
        dependencies: UserSearchFamily._dependencies,
        allTransitiveDependencies: UserSearchFamily._allTransitiveDependencies,
        email: email,
      );

  UserSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
  }) : super.internal();

  final String email;

  @override
  Override overrideWith(
    FutureOr<List<AppUser>> Function(UserSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserSearchProvider._internal(
        (ref) => create(ref as UserSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AppUser>> createElement() {
    return _UserSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserSearchProvider && other.email == email;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserSearchRef on AutoDisposeFutureProviderRef<List<AppUser>> {
  /// The parameter `email` of this provider.
  String get email;
}

class _UserSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<AppUser>>
    with UserSearchRef {
  _UserSearchProviderElement(super.provider);

  @override
  String get email => (origin as UserSearchProvider).email;
}

String _$userFriendsNotifierHash() =>
    r'091aa92d76feac477ca8ba4589c3c1caaa5ce5ae';

/// See also [UserFriendsNotifier].
@ProviderFor(UserFriendsNotifier)
final userFriendsNotifierProvider = AutoDisposeAsyncNotifierProvider<
  UserFriendsNotifier,
  List<AppUser>
>.internal(
  UserFriendsNotifier.new,
  name: r'userFriendsNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userFriendsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserFriendsNotifier = AutoDisposeAsyncNotifier<List<AppUser>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
