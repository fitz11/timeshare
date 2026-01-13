// SPDX-License-Identifier: AGPL-3.0-or-later

/// Exception thrown when a version conflict is detected during an update operation.
///
/// This occurs when the local version of a resource doesn't match the server version,
/// indicating that another user or device has modified the resource.
class ConflictException implements Exception {
  /// A human-readable description of the conflict.
  final String message;

  /// The version number of the local resource that was being updated.
  final int localVersion;

  /// The current version number on the server.
  final int serverVersion;

  /// The current state of the resource on the server.
  /// This can be used to show the user what changed or to retry with merged data.
  final dynamic serverData;

  ConflictException({
    required this.message,
    required this.localVersion,
    required this.serverVersion,
    this.serverData,
  });

  @override
  String toString() =>
      'ConflictException: $message (local: v$localVersion, server: v$serverVersion)';
}
