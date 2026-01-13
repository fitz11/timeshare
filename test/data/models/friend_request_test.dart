// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/models/friend_request/friend_request.dart';

void main() {
  group('FriendRequest', () {
    test('creates with required fields', () {
      final now = DateTime.now();
      final expires = now.add(const Duration(days: 30));

      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        createdAt: now,
        expiresAt: expires,
      );

      expect(request.id, equals('req-1'));
      expect(request.fromUid, equals('user-1'));
      expect(request.toUid, equals('user-2'));
      expect(request.status, equals(FriendRequestStatus.pending));
    });

    test('defaults to pending status', () {
      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );

      expect(request.status, equals(FriendRequestStatus.pending));
    });

    test('can have accepted status', () {
      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: FriendRequestStatus.accepted,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );

      expect(request.status, equals(FriendRequestStatus.accepted));
    });

    test('can have declined status', () {
      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: FriendRequestStatus.declined,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );

      expect(request.status, equals(FriendRequestStatus.declined));
    });

    test('includes denormalized display fields', () {
      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        fromDisplayName: 'Alice',
        fromEmail: 'alice@example.com',
        toDisplayName: 'Bob',
        toEmail: 'bob@example.com',
      );

      expect(request.fromDisplayName, equals('Alice'));
      expect(request.fromEmail, equals('alice@example.com'));
      expect(request.toDisplayName, equals('Bob'));
      expect(request.toEmail, equals('bob@example.com'));
    });
  });

  group('FriendRequest expiration', () {
    test('isExpired returns false for future expiry', () {
      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );

      expect(request.isExpired, isFalse);
    });

    test('isExpired returns true for past expiry', () {
      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        createdAt: DateTime.now().subtract(const Duration(days: 31)),
        expiresAt: DateTime.now().subtract(const Duration(days: 1)),
      );

      expect(request.isExpired, isTrue);
    });

    test('daysUntilExpiry calculates correctly', () {
      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 15)),
      );

      expect(request.daysUntilExpiry, inInclusiveRange(14, 15));
    });

    test('timeUntilExpiry returns Duration', () {
      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );

      expect(request.timeUntilExpiry, isA<Duration>());
      expect(request.timeUntilExpiry.isNegative, isFalse);
    });
  });

  group('FriendRequest isPendingAndValid', () {
    test('returns true for pending non-expired request', () {
      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: FriendRequestStatus.pending,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );

      expect(request.isPendingAndValid, isTrue);
    });

    test('returns false for accepted request', () {
      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: FriendRequestStatus.accepted,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );

      expect(request.isPendingAndValid, isFalse);
    });

    test('returns false for declined request', () {
      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: FriendRequestStatus.declined,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );

      expect(request.isPendingAndValid, isFalse);
    });

    test('returns false for expired pending request', () {
      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: FriendRequestStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 31)),
        expiresAt: DateTime.now().subtract(const Duration(days: 1)),
      );

      expect(request.isPendingAndValid, isFalse);
    });
  });

  group('FriendRequest JSON serialization', () {
    test('serializes to JSON', () {
      final now = DateTime.now().toUtc();
      final expires = now.add(const Duration(days: 30));

      final request = FriendRequest(
        id: 'req-1',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: FriendRequestStatus.pending,
        createdAt: now,
        expiresAt: expires,
        fromDisplayName: 'Alice',
      );

      final json = request.toJson();

      expect(json['id'], equals('req-1'));
      expect(json['fromUid'], equals('user-1'));
      expect(json['toUid'], equals('user-2'));
      expect(json['status'], equals('pending'));
      expect(json['fromDisplayName'], equals('Alice'));
    });

    test('deserializes from JSON', () {
      final now = DateTime.now().toUtc();
      final expires = now.add(const Duration(days: 30));

      final json = {
        'id': 'req-1',
        'fromUid': 'user-1',
        'toUid': 'user-2',
        'status': 'pending',
        'createdAt': now.toIso8601String(),
        'expiresAt': expires.toIso8601String(),
        'fromDisplayName': 'Alice',
      };

      final request = FriendRequest.fromJson(json);

      expect(request.id, equals('req-1'));
      expect(request.fromUid, equals('user-1'));
      expect(request.toUid, equals('user-2'));
      expect(request.status, equals(FriendRequestStatus.pending));
      expect(request.fromDisplayName, equals('Alice'));
    });

    test('deserializes status enum correctly', () {
      final now = DateTime.now().toUtc();
      final expires = now.add(const Duration(days: 30));

      final pendingJson = {
        'id': 'req-1',
        'fromUid': 'user-1',
        'toUid': 'user-2',
        'status': 'pending',
        'createdAt': now.toIso8601String(),
        'expiresAt': expires.toIso8601String(),
      };

      final acceptedJson = {
        'id': 'req-2',
        'fromUid': 'user-1',
        'toUid': 'user-2',
        'status': 'accepted',
        'createdAt': now.toIso8601String(),
        'expiresAt': expires.toIso8601String(),
      };

      final declinedJson = {
        'id': 'req-3',
        'fromUid': 'user-1',
        'toUid': 'user-2',
        'status': 'declined',
        'createdAt': now.toIso8601String(),
        'expiresAt': expires.toIso8601String(),
      };

      expect(
        FriendRequest.fromJson(pendingJson).status,
        equals(FriendRequestStatus.pending),
      );
      expect(
        FriendRequest.fromJson(acceptedJson).status,
        equals(FriendRequestStatus.accepted),
      );
      expect(
        FriendRequest.fromJson(declinedJson).status,
        equals(FriendRequestStatus.declined),
      );
    });
  });
}
