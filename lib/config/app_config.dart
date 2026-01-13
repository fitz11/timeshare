// SPDX-License-Identifier: AGPL-3.0-or-later

/// Available runtime environments.
enum Environment { dev, staging, prod }

/// Application configuration that varies by environment.
///
/// Usage:
/// ```bash
/// flutter run --dart-define=ENV=dev      # Local development
/// flutter run --dart-define=ENV=staging  # Staging server
/// flutter run --dart-define=ENV=prod     # Production
/// ```
class AppConfig {
  final Environment environment;
  final String apiBaseUrl;

  const AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
  });

  /// Development configuration - local server.
  static const dev = AppConfig._(
    environment: Environment.dev,
    apiBaseUrl: 'http://localhost:8000',
  );

  /// Staging configuration - staging server.
  static const staging = AppConfig._(
    environment: Environment.staging,
    apiBaseUrl: 'https://staging.squishygoose.dev',
  );

  /// Production configuration - production server.
  static const prod = AppConfig._(
    environment: Environment.prod,
    apiBaseUrl: 'https://squishygoose.dev',
  );

  /// Get configuration from the ENV compile-time variable.
  /// Defaults to [dev] if not specified.
  static AppConfig fromEnvironment() {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    switch (env) {
      case 'prod':
        return prod;
      case 'staging':
        return staging;
      default:
        return dev;
    }
  }

  /// Whether this is a development environment.
  bool get isDev => environment == Environment.dev;

  /// Whether this is a production environment.
  bool get isProd => environment == Environment.prod;
}
