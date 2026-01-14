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
final authServiceProvider = AuthServiceProvider._();

/// Auth service provider - creates RestApiAuthService with secure storage.
/// This is the main authentication service for the app.

final class AuthServiceProvider
    extends $FunctionalProvider<AuthService, AuthService, AuthService>
    with $Provider<AuthService> {
  /// Auth service provider - creates RestApiAuthService with secure storage.
  /// This is the main authentication service for the app.
  AuthServiceProvider._()
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

String _$authServiceHash() => r'bc171ee95e9a49fe364b6a9b4c9205c2cb8e7509';

/// Stream of authentication state changes.
/// Use this to react to login/logout events.

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

/// Stream of authentication state changes.
/// Use this to react to login/logout events.

final class AuthStateProvider
    extends
        $FunctionalProvider<AsyncValue<AuthState>, AuthState, Stream<AuthState>>
    with $FutureModifier<AuthState>, $StreamProvider<AuthState> {
  /// Stream of authentication state changes.
  /// Use this to react to login/logout events.
  AuthStateProvider._()
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

String _$authStateHash() => r'7c386d773e9ed4a78b154032ac397367825d8523';

/// Current user ID - synchronous access to the current user's UID.
/// Returns null if not logged in.

@ProviderFor(currentUserId)
final currentUserIdProvider = CurrentUserIdProvider._();

/// Current user ID - synchronous access to the current user's UID.
/// Returns null if not logged in.

final class CurrentUserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Current user ID - synchronous access to the current user's UID.
  /// Returns null if not logged in.
  CurrentUserIdProvider._()
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

String _$currentUserIdHash() => r'2cf739586b6999a1df82ea76cc14d3028aa900c0';

/// Sign out the current user.
/// Revokes the API key server-side and clears stored credentials.

@ProviderFor(signOut)
final signOutProvider = SignOutProvider._();

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
  SignOutProvider._()
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
final changePasswordProvider = ChangePasswordProvider._();

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
  ChangePasswordProvider._()
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
final changeEmailProvider = ChangeEmailProvider._();

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
  ChangeEmailProvider._()
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
final requestPasswordResetProvider = RequestPasswordResetProvider._();

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
  RequestPasswordResetProvider._()
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

/// Email pending verification - the email that needs to be verified.

@ProviderFor(pendingVerificationEmail)
final pendingVerificationEmailProvider = PendingVerificationEmailProvider._();

/// Email pending verification - the email that needs to be verified.

final class PendingVerificationEmailProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Email pending verification - the email that needs to be verified.
  PendingVerificationEmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingVerificationEmailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingVerificationEmailHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return pendingVerificationEmail(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pendingVerificationEmailHash() =>
    r'e9212798703be9f4197c0f42e42d464791eaf46e';

/// Verify email with a token.

@ProviderFor(verifyEmail)
final verifyEmailProvider = VerifyEmailProvider._();

/// Verify email with a token.

final class VerifyEmailProvider
    extends
        $FunctionalProvider<
          Future<String> Function(String token),
          Future<String> Function(String token),
          Future<String> Function(String token)
        >
    with $Provider<Future<String> Function(String token)> {
  /// Verify email with a token.
  VerifyEmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verifyEmailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verifyEmailHash();

  @$internal
  @override
  $ProviderElement<Future<String> Function(String token)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<String> Function(String token) create(Ref ref) {
    return verifyEmail(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<String> Function(String token) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Future<String> Function(String token)>(value),
    );
  }
}

String _$verifyEmailHash() => r'ac068edf5d63f83e44f492a5cdd5c2d62a43169c';

/// Resend verification email.

@ProviderFor(resendVerificationEmail)
final resendVerificationEmailProvider = ResendVerificationEmailProvider._();

/// Resend verification email.

final class ResendVerificationEmailProvider
    extends
        $FunctionalProvider<
          Future<void> Function(String email),
          Future<void> Function(String email),
          Future<void> Function(String email)
        >
    with $Provider<Future<void> Function(String email)> {
  /// Resend verification email.
  ResendVerificationEmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resendVerificationEmailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resendVerificationEmailHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function(String email)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function(String email) create(Ref ref) {
    return resendVerificationEmail(ref);
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

String _$resendVerificationEmailHash() =>
    r'ed2fb65bd69c998c63e403a2af93c8cab1b0a1d6';

/// Cancel pending verification and return to unauthenticated state.

@ProviderFor(cancelPendingVerification)
final cancelPendingVerificationProvider = CancelPendingVerificationProvider._();

/// Cancel pending verification and return to unauthenticated state.

final class CancelPendingVerificationProvider
    extends
        $FunctionalProvider<void Function(), void Function(), void Function()>
    with $Provider<void Function()> {
  /// Cancel pending verification and return to unauthenticated state.
  CancelPendingVerificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cancelPendingVerificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cancelPendingVerificationHash();

  @$internal
  @override
  $ProviderElement<void Function()> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void Function() create(Ref ref) {
    return cancelPendingVerification(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void Function()>(value),
    );
  }
}

String _$cancelPendingVerificationHash() =>
    r'aee6d2571364b5fc8f82012aa70cb0b5f39552c1';
