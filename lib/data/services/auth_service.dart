// SPDX-License-Identifier: AGPL-3.0-or-later

/// Abstract interface for authentication services.
///
/// This abstraction allows swapping between different auth implementations
/// (Firebase Auth, REST API with API keys, etc.) without changing the consuming code.
abstract class AuthService {
  /// The currently authenticated user's ID, or null if not authenticated.
  String? get currentUserId;

  /// The current API key, or null if not authenticated.
  /// Used for Authorization header in API requests.
  String? get apiKey;

  /// Stream of authentication state changes.
  Stream<AuthState> get authStateStream;

  /// Authenticate with email and password.
  /// Returns the user ID on success. API key is stored internally.
  Future<String> login(String email, String password);

  /// Create a new account with email, password, and display name.
  /// Returns the user ID on success. API key is stored internally.
  Future<String> signup(String email, String password, String displayName);

  /// Sign out the current user.
  /// Revokes the API key server-side and clears stored credentials.
  Future<void> logout();

  /// Load stored credentials on app startup.
  /// Returns true if a valid session was restored.
  Future<bool> loadStoredCredentials();

  /// Change the current user's password.
  /// Requires the current password for verification.
  /// Throws [AuthException] on failure.
  Future<void> changePassword(String currentPassword, String newPassword);

  /// Change the current user's email address.
  /// Requires the current password for verification.
  /// Throws [AuthException] on failure.
  Future<void> changeEmail(String newEmail, String password);

  /// Request a password reset email for the given email address.
  /// Always succeeds from the client's perspective (to prevent email enumeration).
  Future<void> requestPasswordReset(String email);

  /// The email address pending verification, or null if not in pending state.
  String? get pendingVerificationEmail;

  /// Verify email with the token from the verification link.
  /// Returns the user ID on success. Stores API key internally.
  /// Throws [AuthException] on failure.
  Future<String> verifyEmail(String token);

  /// Resend verification email for the given email address.
  /// Always succeeds from the client's perspective (prevents email enumeration).
  Future<void> resendVerificationEmail(String email);

  /// Clear the pending verification state and return to unauthenticated.
  void cancelPendingVerification();
}

/// Represents the current authentication state.
enum AuthState {
  /// No user is authenticated.
  unauthenticated,

  /// Authentication is in progress (loading stored credentials, etc.).
  loading,

  /// A user is authenticated.
  authenticated,

  /// User registered but email not yet verified.
  pendingVerification,

  /// An error occurred during authentication.
  error,
}
