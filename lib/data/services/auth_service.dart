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
}

/// Represents the current authentication state.
enum AuthState {
  /// No user is authenticated.
  unauthenticated,

  /// Authentication is in progress (loading stored credentials, etc.).
  loading,

  /// A user is authenticated.
  authenticated,

  /// An error occurred during authentication.
  error,
}
