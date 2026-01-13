import 'package:timeshare/data/models/user/app_user.dart';
import 'package:timeshare/data/repo/user_repo_interface.dart';
import 'package:timeshare/services/logging/app_logger.dart';

/// Decorator that wraps a UserRepositoryInterface to add logging.
///
/// All API operations are logged with timing metrics.
class LoggedUserRepository implements UserRepositoryInterface {
  final UserRepositoryInterface _delegate;
  final AppLogger _logger;

  LoggedUserRepository(this._delegate, this._logger);

  @override
  String? get currentUserId => _delegate.currentUserId;

  @override
  Future<AppUser?> get currentUser {
    return _logger.logApiCall(
      'getCurrentUser',
      () => _delegate.currentUser,
    );
  }

  @override
  Future<void> signInOrRegister() {
    return _logger.logApiCall(
      'signInOrRegister',
      () => _delegate.signInOrRegister(),
    );
  }

  @override
  Future<AppUser?> getUserById([String uid = '']) {
    return _logger.logApiCall(
      'getUserById',
      () => _delegate.getUserById(uid),
    );
  }

  @override
  Future<List<AppUser>> searchUsersByEmail(String email) {
    return _logger.logApiCall(
      'searchUsersByEmail',
      () => _delegate.searchUsersByEmail(email),
    );
  }

  @override
  Future<List<AppUser>> getFriendsOfUser([String uid = '']) {
    return _logger.logApiCall(
      'getFriendsOfUser',
      () => _delegate.getFriendsOfUser(uid),
    );
  }

  @override
  Future<void> addFriend(String targetUid) {
    return _logger.logApiCall(
      'addFriend',
      () => _delegate.addFriend(targetUid),
    );
  }

  @override
  Future<void> removeFriend(String targetUid) {
    return _logger.logApiCall(
      'removeFriend',
      () => _delegate.removeFriend(targetUid),
    );
  }

  @override
  Future<void> updateDisplayName(String newDisplayName) {
    return _logger.logApiCall(
      'updateDisplayName',
      () => _delegate.updateDisplayName(newDisplayName),
    );
  }

  @override
  Future<void> deleteUserAccount() {
    return _logger.logApiCall(
      'deleteUserAccount',
      () => _delegate.deleteUserAccount(),
    );
  }
}
