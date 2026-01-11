/// Tracks API call frequency to detect excessive calls.
///
/// Uses a sliding window to count calls per operation and flag
/// when the rate exceeds a configurable threshold.
class ApiCallTracker {
  final String operationName;
  final int windowSeconds;
  final int maxCallsPerWindow;
  final List<DateTime> _callTimestamps = [];

  ApiCallTracker({
    required this.operationName,
    this.windowSeconds = 60,
    this.maxCallsPerWindow = 50,
  });

  /// Records a new API call timestamp.
  void recordCall() {
    final now = DateTime.now();
    _callTimestamps.add(now);
    _cleanOldTimestamps(now);
  }

  /// Removes timestamps outside the sliding window.
  void _cleanOldTimestamps(DateTime now) {
    final cutoff = now.subtract(Duration(seconds: windowSeconds));
    _callTimestamps.removeWhere((t) => t.isBefore(cutoff));
  }

  /// Whether the call rate exceeds the threshold.
  bool get isExcessive => _callTimestamps.length > maxCallsPerWindow;

  /// Number of calls in the current window.
  int get callCountInWindow => _callTimestamps.length;

  /// Calls per minute (normalized rate).
  double get callsPerMinute {
    if (_callTimestamps.isEmpty) return 0;
    return _callTimestamps.length * (60 / windowSeconds);
  }
}
