// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authHash() => r'32f5302faf182139a28024fdbc77728e9b3c1598';

/// See also [auth].
@ProviderFor(auth)
final authProvider = AutoDisposeProvider<FirebaseAuth>.internal(
  auth,
  name: r'authProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRef = AutoDisposeProviderRef<FirebaseAuth>;
String _$authStateHash() => r'de0bbcad474f895e6e4551e9e5730a0a1c7434b3';

/// See also [authState].
@ProviderFor(authState)
final authStateProvider = AutoDisposeStreamProvider<User?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = AutoDisposeStreamProviderRef<User?>;
String _$signInControllerHash() => r'd0958332a539341343c27377264ecab914297e63';

/// See also [SignInController].
@ProviderFor(SignInController)
final signInControllerProvider =
    AutoDisposeAsyncNotifierProvider<SignInController, void>.internal(
      SignInController.new,
      name: r'signInControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$signInControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SignInController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
