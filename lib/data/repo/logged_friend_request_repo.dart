// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:timeshare/data/models/friend_request/friend_request.dart';
import 'package:timeshare/data/repo/friend_request_repo.dart';
import 'package:timeshare/services/logging/app_logger.dart';

/// Decorator that wraps a FriendRequestRepository to add logging.
///
/// All API operations are logged with timing metrics.
class LoggedFriendRequestRepository implements FriendRequestRepository {
  final FriendRequestRepository _delegate;
  final AppLogger _logger;

  LoggedFriendRequestRepository(this._delegate, this._logger);

  @override
  Future<List<FriendRequest>> getIncomingRequests() {
    return _logger.logApiCall(
      'getIncomingRequests',
      () => _delegate.getIncomingRequests(),
    );
  }

  @override
  Future<List<FriendRequest>> getSentRequests() {
    return _logger.logApiCall(
      'getSentRequests',
      () => _delegate.getSentRequests(),
    );
  }

  @override
  Future<FriendRequest> sendRequest(String targetUid) {
    return _logger.logApiCall(
      'sendFriendRequest',
      () => _delegate.sendRequest(targetUid),
    );
  }

  @override
  Future<void> acceptRequest(String requestId) {
    return _logger.logApiCall(
      'acceptFriendRequest',
      () => _delegate.acceptRequest(requestId),
    );
  }

  @override
  Future<void> declineRequest(String requestId) {
    return _logger.logApiCall(
      'declineFriendRequest',
      () => _delegate.declineRequest(requestId),
    );
  }

  @override
  Future<void> cancelRequest(String requestId) {
    return _logger.logApiCall(
      'cancelFriendRequest',
      () => _delegate.cancelRequest(requestId),
    );
  }

  @override
  Stream<List<FriendRequest>> watchIncomingRequests() {
    _logger.logStreamSubscription('watchIncomingFriendRequests');
    return _delegate.watchIncomingRequests();
  }
}
