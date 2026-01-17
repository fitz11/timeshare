// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/foundation.dart';
import 'package:timeshare/config/app_config.dart';
import 'package:timeshare/services/logging/api_call_tracker.dart';

/// Log level for the app logger.
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// Centralized logging service for the app.
///
/// Provides structured logging with environment-based minimum levels:
/// - Dev/Staging: All levels (debug and above)
/// - Production: Warnings and errors only
///
/// Also tracks API call rates to detect excessive calls.
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  bool _initialized = false;
  LogLevel _minLevel = LogLevel.debug;

  /// API call trackers by operation name.
  final Map<String, ApiCallTracker> _apiCallTrackers = {};

  /// Threshold for slow API calls (milliseconds).
  static const int slowCallThresholdMs = 3000;

  /// Current minimum log level.
  LogLevel get minLevel => _minLevel;

  /// Initialize the logger. Call once at app startup.
  /// Safe to skip in tests - logger will use debugPrint fallback.
  Future<void> initialize({AppConfig? config}) async {
    if (_initialized) return;

    final appConfig = config ?? AppConfig.fromEnvironment();
    _minLevel = _getMinLevelForEnvironment(appConfig);

    _initialized = true;
    info('AppLogger initialized (minLevel: ${_minLevel.name}, env: ${appConfig.environment.name})', tag: 'Logger');
  }

  /// Determine minimum log level based on environment.
  LogLevel _getMinLevelForEnvironment(AppConfig config) {
    switch (config.environment) {
      case Environment.prod:
        return LogLevel.warning;
      case Environment.staging:
      case Environment.dev:
        return LogLevel.debug;
    }
  }

  /// Check if a log level should be output.
  bool _shouldLog(LogLevel level) {
    return level.index >= _minLevel.index;
  }

  String _formatMessage(String message, String? tag) {
    return tag != null ? '[$tag] $message' : message;
  }

  /// Log debug message.
  void debug(String message, {String? tag}) {
    if (!_shouldLog(LogLevel.debug)) return;
    final formatted = _formatMessage(message, tag);
    debugPrint('[DEBUG] $formatted');
  }

  /// Log info message.
  void info(String message, {String? tag}) {
    if (!_shouldLog(LogLevel.info)) return;
    final formatted = _formatMessage(message, tag);
    debugPrint('[INFO] $formatted');
  }

  /// Log warning message.
  void warning(String message, {String? tag}) {
    if (!_shouldLog(LogLevel.warning)) return;
    final formatted = _formatMessage(message, tag);
    debugPrint('[WARNING] $formatted');
  }

  /// Log error message.
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
    bool fatal = false,
  }) {
    if (!_shouldLog(LogLevel.error)) return;
    final formatted = _formatMessage(message, tag);
    debugPrint('[ERROR] $formatted');
    if (error != null) debugPrint('Error: $error');
    if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
  }

  /// Execute and log an API call with timing.
  ///
  /// Tracks call rate and logs timing.
  Future<T> logApiCall<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    _trackApiCall(operationName);

    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation();
      stopwatch.stop();

      final elapsed = stopwatch.elapsedMilliseconds;

      // Verbose timing in debug mode
      if (kDebugMode) {
        debug('$operationName completed in ${elapsed}ms', tag: 'API');
      }

      // Log slow operations
      if (elapsed > slowCallThresholdMs) {
        warning('Slow API call: $operationName took ${elapsed}ms', tag: 'API');
      }

      return result;
    } catch (e, st) {
      stopwatch.stop();
      error(
        '$operationName failed after ${stopwatch.elapsedMilliseconds}ms',
        error: e,
        stackTrace: st,
        tag: 'API',
      );
      rethrow;
    }
  }

  /// Log a stream subscription (called once when stream is subscribed).
  void logStreamSubscription(String operationName) {
    _trackApiCall(operationName);
    debug('Stream subscribed: $operationName', tag: 'API');
  }

  /// Track an API call for rate limiting detection.
  void _trackApiCall(String operationName) {
    _apiCallTrackers.putIfAbsent(
      operationName,
      () => ApiCallTracker(operationName: operationName),
    );

    final tracker = _apiCallTrackers[operationName]!;
    tracker.recordCall();

    if (tracker.isExcessive) {
      warning(
        'Excessive API calls: $operationName called '
        '${tracker.callCountInWindow} times in last minute',
        tag: 'RateLimit',
      );
    }
  }

  /// Get current call count for an operation (useful for testing).
  int getCallCount(String operationName) {
    return _apiCallTrackers[operationName]?.callCountInWindow ?? 0;
  }
}
