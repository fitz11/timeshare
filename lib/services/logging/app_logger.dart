// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:timeshare/services/logging/api_call_tracker.dart';

/// Centralized logging service for the app.
///
/// Provides structured logging with different behavior for debug and release:
/// - Debug: Verbose console output for all levels
/// - Release: Errors only, logged to console
///
/// Also tracks API call rates to detect excessive calls.
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  Logger? _logger;
  bool _initialized = false;

  /// API call trackers by operation name.
  final Map<String, ApiCallTracker> _apiCallTrackers = {};

  /// Threshold for slow API calls (milliseconds).
  static const int slowCallThresholdMs = 3000;

  /// Initialize the logger. Call once at app startup.
  /// Safe to skip in tests - logger will use debugPrint fallback.
  Future<void> initialize() async {
    if (_initialized) return;

    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: kDebugMode ? Level.debug : Level.warning,
    );

    _initialized = true;
    debug('AppLogger initialized', tag: 'Logger');
  }

  String _formatMessage(String message, String? tag) {
    return tag != null ? '[$tag] $message' : message;
  }

  /// Log debug message (debug mode only).
  void debug(String message, {String? tag}) {
    if (!kDebugMode) return;
    final formatted = _formatMessage(message, tag);
    if (_logger != null) {
      _logger!.d(formatted);
    } else {
      debugPrint('[DEBUG] $formatted');
    }
  }

  /// Log info message (debug mode only).
  void info(String message, {String? tag}) {
    if (!kDebugMode) return;
    final formatted = _formatMessage(message, tag);
    if (_logger != null) {
      _logger!.i(formatted);
    } else {
      debugPrint('[INFO] $formatted');
    }
  }

  /// Log warning message (always logged).
  void warning(String message, {String? tag}) {
    final formatted = _formatMessage(message, tag);
    if (_logger != null) {
      _logger!.w(formatted);
    } else {
      debugPrint('[WARNING] $formatted');
    }
  }

  /// Log error message (always logged).
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
    bool fatal = false,
  }) {
    final formatted = _formatMessage(message, tag);
    if (_logger != null) {
      _logger!.e(formatted, error: error, stackTrace: stackTrace);
    } else {
      debugPrint('[ERROR] $formatted');
      if (error != null) debugPrint('Error: $error');
    }
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
