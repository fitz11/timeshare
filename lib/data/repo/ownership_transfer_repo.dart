// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:timeshare/data/models/ownership_transfer/ownership_transfer_request.dart';

/// Abstract interface for calendar ownership transfer operations.
///
/// This abstraction allows swapping between different backend implementations
/// (Firebase, REST API, etc.) without changing the consuming code.
abstract class OwnershipTransferRepository {
  /// Get all pending transfer requests sent TO the current user.
  Future<List<OwnershipTransferRequest>> getIncomingTransfers();

  /// Get all pending transfer requests sent BY the current user.
  Future<List<OwnershipTransferRequest>> getSentTransfers();

  /// Request to transfer ownership of a calendar to another user.
  ///
  /// Only the calendar owner can initiate a transfer.
  /// The recipient must accept before becoming the new owner.
  Future<OwnershipTransferRequest> requestTransfer(
    String calendarId,
    String toUid,
  );

  /// Accept a pending transfer request.
  ///
  /// This changes the calendar's owner to the current user.
  Future<void> acceptTransfer(String requestId);

  /// Decline a pending transfer request.
  ///
  /// The request status is updated to declined.
  Future<void> declineTransfer(String requestId);

  /// Cancel a sent transfer request.
  ///
  /// Only the sender (current owner) can cancel.
  Future<void> cancelTransfer(String requestId);

  /// Stream of incoming transfer requests (polling-based for REST API).
  ///
  /// This stream will periodically poll for updates since REST APIs
  /// don't support real-time subscriptions.
  Stream<List<OwnershipTransferRequest>> watchIncomingTransfers();
}
