import 'package:timeshare/data/models/user/app_user.dart';
import 'package:timeshare/data/repo/user_repo.dart';
import 'package:timeshare/services/logging/app_logger.dart';

/// Decorator that wraps a UserRepository to add logging.
///
/// All Firestore operations are logged with timing metrics.
class LoggedUserRepository {
  final UserRepository _delegate;
  final AppLogger _logger;

  LoggedUserRepository(this._delegate, this._logger);

  /// Passthrough to delegate - no Firestore operation.
  String? get currentUserId => _delegate.currentUserId;

  /// Get current user with logging.
  Future<AppUser?> get currentUser {
    return _logger.logApiCall(
      'getCurrentUser',
      () => _delegate.currentUser,
    );
  }

  Future<void> signInOrRegister() {
    return _logger.logApiCall(
      'signInOrRegister',
      () => _delegate.signInOrRegister(),
    );
  }

  Future<AppUser?> getUserById([String uid = '']) {
    return _logger.logApiCall(
      'getUserById',
      () => _delegate.getUserById(uid),
    );
  }

  Future<List<AppUser>> searchUsersByEmail(String email) {
    return _logger.logApiCall(
      'searchUsersByEmail',
      () => _delegate.searchUsersByEmail(email),
    );
  }

  Future<List<AppUser>> getFriendsOfUser([String uid = '']) {
    return _logger.logApiCall(
      'getFriendsOfUser',
      () => _delegate.getFriendsOfUser(uid),
    );
  }

  Future<void> addFriend(String targetUid) {
    return _logger.logApiCall(
      'addFriend',
      () => _delegate.addFriend(targetUid),
    );
  }

  Future<void> removeFriend(String targetUid) {
    return _logger.logApiCall(
      'removeFriend',
      () => _delegate.removeFriend(targetUid),
    );
  }

  Future<void> updateDisplayName(String newDisplayName) {
    return _logger.logApiCall(
      'updateDisplayName',
      () => _delegate.updateDisplayName(newDisplayName),
    );
  }

  Future<void> deleteUserAccount() {
    return _logger.logApiCall(
      'deleteUserAccount',
      () => _delegate.deleteUserAccount(),
    );
  }
}
