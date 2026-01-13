// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auth service provider - creates RestApiAuthService with secure storage.
/// This is the main authentication service for the app.

@ProviderFor(authService)
const authServiceProvider = AuthServiceProvider._();

/// Auth service provider - creates RestApiAuthService with secure storage.
/// This is the main authentication service for the app.

final class AuthServiceProvider
    extends $FunctionalProvider<AuthService, AuthService, AuthService>
    with $Provider<AuthService> {
  /// Auth service provider - creates RestApiAuthService with secure storage.
  /// This is the main authentication service for the app.
  const AuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceHash();

  @$internal
  @override
  $ProviderElement<AuthService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthService create(Ref ref) {
    return authService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthService>(value),
    );
  }
}

String _$authServiceHash() => r'427fc5706db9dc1b3093bc065dbf7ed5d1d76c4d';

/// Stream of authentication state changes.
/// Use this to react to login/logout events.

@ProviderFor(authState)
const authStateProvider = AuthStateProvider._();

/// Stream of authentication state changes.
/// Use this to react to login/logout events.

final class AuthStateProvider
    extends
        $FunctionalProvider<AsyncValue<AuthState>, AuthState, Stream<AuthState>>
    with $FutureModifier<AuthState>, $StreamProvider<AuthState> {
  /// Stream of authentication state changes.
  /// Use this to react to login/logout events.
  const AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $StreamProviderElement<AuthState> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AuthState> create(Ref ref) {
    return authState(ref);
  }
}

String _$authStateHash() => r'bd5da458de66f08e9ed18bc1b68ace9d936fd6f4';

/// Current user ID - synchronous access to the current user's UID.
/// Returns null if not logged in.

@ProviderFor(currentUserId)
const currentUserIdProvider = CurrentUserIdProvider._();

/// Current user ID - synchronous access to the current user's UID.
/// Returns null if not logged in.

final class CurrentUserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Current user ID - synchronous access to the current user's UID.
  /// Returns null if not logged in.
  const CurrentUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentUserIdHash() => r'56589a806d33eea9e557b8340b0bdfe0cbe84984';

/// Sign out the current user.
/// Revokes the API key server-side and clears stored credentials.

@ProviderFor(signOut)
const signOutProvider = SignOutProvider._();

/// Sign out the current user.
/// Revokes the API key server-side and clears stored credentials.

final class SignOutProvider
    extends
        $FunctionalProvider<
          Future<void> Function(),
          Future<void> Function(),
          Future<void> Function()
        >
    with $Provider<Future<void> Function()> {
  /// Sign out the current user.
  /// Revokes the API key server-side and clears stored credentials.
  const SignOutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signOutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signOutHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function() create(Ref ref) {
    return signOut(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<void> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<void> Function()>(value),
    );
  }
}

String _$signOutHash() => r'acde860d503d02fd8f3ab3692b07873e63fa0fef';

/// Change the current user's password.

@ProviderFor(changePassword)
const changePasswordProvider = ChangePasswordProvider._();

/// Change the current user's password.

final class ChangePasswordProvider
    extends
        $FunctionalProvider<
          Future<void> Function(String currentPassword, String newPassword),
          Future<void> Function(String currentPassword, String newPassword),
          Future<void> Function(String currentPassword, String newPassword)
        >
    with
        $Provider<
          Future<void> Function(String currentPassword, String newPassword)
        > {
  /// Change the current user's password.
  const ChangePasswordProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changePasswordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changePasswordHash();

  @$internal
  @override
  $ProviderElement<
    Future<void> Function(String currentPassword, String newPassword)
  >
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Future<void> Function(String currentPassword, String newPassword) create(
    Ref ref,
  ) {
    return changePassword(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Future<void> Function(String currentPassword, String newPassword) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Future<void> Function(String currentPassword, String newPassword)
          >(value),
    );
  }
}

String _$changePasswordHash() => r'8f6b83688e03c3bfcafe0b171ae88dd2ea8dea6a';

/// Change the current user's email address.

@ProviderFor(changeEmail)
const changeEmailProvider = ChangeEmailProvider._();

/// Change the current user's email address.

final class ChangeEmailProvider
    extends
        $FunctionalProvider<
          Future<void> Function(String newEmail, String password),
          Future<void> Function(String newEmail, String password),
          Future<void> Function(String newEmail, String password)
        >
    with $Provider<Future<void> Function(String newEmail, String password)> {
  /// Change the current user's email address.
  const ChangeEmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changeEmailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changeEmailHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function(String newEmail, String password)>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Future<void> Function(String newEmail, String password) create(Ref ref) {
    return changeEmail(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Future<void> Function(String newEmail, String password) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Future<void> Function(String newEmail, String password)
          >(value),
    );
  }
}

String _$changeEmailHash() => r'5e66b13fcd277f2ce8a00c02a86ddd835153e036';

/// Request a password reset email.

@ProviderFor(requestPasswordReset)
const requestPasswordResetProvider = RequestPasswordResetProvider._();

/// Request a password reset email.

final class RequestPasswordResetProvider
    extends
        $FunctionalProvider<
          Future<void> Function(String email),
          Future<void> Function(String email),
          Future<void> Function(String email)
        >
    with $Provider<Future<void> Function(String email)> {
  /// Request a password reset email.
  const RequestPasswordResetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestPasswordResetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestPasswordResetHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function(String email)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function(String email) create(Ref ref) {
    return requestPasswordReset(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<void> Function(String email) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<void> Function(String email)>(
        value,
      ),
    );
  }
}

String _$requestPasswordResetHash() =>
    r'd260d59c29b6366359f45f0afd697365870f8312';
