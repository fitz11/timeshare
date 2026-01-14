// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timeshare/data/services/rest_api_auth_service.dart';

/// Platform implementation of [SecureStorage] using flutter_secure_storage.
///
/// Uses encrypted shared preferences on Android, Keychain on iOS,
/// and encrypted localStorage on web.
class FlutterSecureStorageImpl implements SecureStorage {
  FlutterSecureStorage? _storage;
  bool _initFailed = false;

  FlutterSecureStorage? get _safeStorage {
    if (_initFailed) return null;
    if (_storage != null) return _storage;

    try {
      _storage = FlutterSecureStorage(
        aOptions: AndroidOptions(),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        webOptions: const WebOptions(),
      );
      return _storage;
    } catch (e) {
      debugPrint('SecureStorage initialization failed: $e');
      _initFailed = true;
      return null;
    }
  }

  @override
  Future<String?> read({required String key}) async {
    final storage = _safeStorage;
    if (storage == null) return null;

    try {
      return await storage.read(key: key);
    } catch (e) {
      debugPrint('SecureStorage read error for key "$key": $e');
      return null;
    }
  }

  @override
  Future<void> write({required String key, required String value}) async {
    final storage = _safeStorage;
    if (storage == null) return;

    try {
      await storage.write(key: key, value: value);
    } catch (e) {
      debugPrint('SecureStorage write error for key "$key": $e');
    }
  }

  @override
  Future<void> delete({required String key}) async {
    final storage = _safeStorage;
    if (storage == null) return;

    try {
      await storage.delete(key: key);
    } catch (e) {
      debugPrint('SecureStorage delete error for key "$key": $e');
    }
  }

  @override
  Future<void> deleteAll() async {
    final storage = _safeStorage;
    if (storage == null) return;

    try {
      await storage.deleteAll();
    } catch (e) {
      debugPrint('SecureStorage deleteAll error: $e');
    }
  }
}
