// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:timeshare/data/models/ownership_transfer/ownership_transfer_request.dart';
import 'package:timeshare/data/repo/ownership_transfer_repo.dart';
import 'package:timeshare/services/logging/app_logger.dart';

/// Decorator that wraps an OwnershipTransferRepository to add logging.
///
/// All API operations are logged with timing metrics.
class LoggedOwnershipTransferRepository implements OwnershipTransferRepository {
  final OwnershipTransferRepository _delegate;
  final AppLogger _logger;

  LoggedOwnershipTransferRepository(this._delegate, this._logger);

  @override
  Future<List<OwnershipTransferRequest>> getIncomingTransfers() {
    return _logger.logApiCall(
      'getIncomingTransfers',
      () => _delegate.getIncomingTransfers(),
    );
  }

  @override
  Future<List<OwnershipTransferRequest>> getSentTransfers() {
    return _logger.logApiCall(
      'getSentTransfers',
      () => _delegate.getSentTransfers(),
    );
  }

  @override
  Future<OwnershipTransferRequest> requestTransfer(
    String calendarId,
    String toUid,
  ) {
    return _logger.logApiCall(
      'requestOwnershipTransfer',
      () => _delegate.requestTransfer(calendarId, toUid),
    );
  }

  @override
  Future<void> acceptTransfer(String requestId) {
    return _logger.logApiCall(
      'acceptOwnershipTransfer',
      () => _delegate.acceptTransfer(requestId),
    );
  }

  @override
  Future<void> declineTransfer(String requestId) {
    return _logger.logApiCall(
      'declineOwnershipTransfer',
      () => _delegate.declineTransfer(requestId),
    );
  }

  @override
  Future<void> cancelTransfer(String requestId) {
    return _logger.logApiCall(
      'cancelOwnershipTransfer',
      () => _delegate.cancelTransfer(requestId),
    );
  }

  @override
  Stream<List<OwnershipTransferRequest>> watchIncomingTransfers() {
    _logger.logStreamSubscription('watchIncomingOwnershipTransfers');
    return _delegate.watchIncomingTransfers();
  }
}
