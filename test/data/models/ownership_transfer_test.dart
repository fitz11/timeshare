// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/models/ownership_transfer/ownership_transfer_request.dart';

void main() {
  group('OwnershipTransferRequest', () {
    test('creates with required fields', () {
      final now = DateTime.now();

      final request = OwnershipTransferRequest(
        id: 'transfer-1',
        calendarId: 'cal-1',
        calendarName: 'My Calendar',
        fromUid: 'user-1',
        toUid: 'user-2',
        createdAt: now,
      );

      expect(request.id, equals('transfer-1'));
      expect(request.calendarId, equals('cal-1'));
      expect(request.calendarName, equals('My Calendar'));
      expect(request.fromUid, equals('user-1'));
      expect(request.toUid, equals('user-2'));
      expect(request.status, equals(TransferStatus.pending));
    });

    test('defaults to pending status', () {
      final request = OwnershipTransferRequest(
        id: 'transfer-1',
        calendarId: 'cal-1',
        calendarName: 'My Calendar',
        fromUid: 'user-1',
        toUid: 'user-2',
        createdAt: DateTime.now(),
      );

      expect(request.status, equals(TransferStatus.pending));
    });

    test('can have accepted status', () {
      final request = OwnershipTransferRequest(
        id: 'transfer-1',
        calendarId: 'cal-1',
        calendarName: 'My Calendar',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: TransferStatus.accepted,
        createdAt: DateTime.now(),
      );

      expect(request.status, equals(TransferStatus.accepted));
    });

    test('can have declined status', () {
      final request = OwnershipTransferRequest(
        id: 'transfer-1',
        calendarId: 'cal-1',
        calendarName: 'My Calendar',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: TransferStatus.declined,
        createdAt: DateTime.now(),
      );

      expect(request.status, equals(TransferStatus.declined));
    });

    test('can have cancelled status', () {
      final request = OwnershipTransferRequest(
        id: 'transfer-1',
        calendarId: 'cal-1',
        calendarName: 'My Calendar',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: TransferStatus.cancelled,
        createdAt: DateTime.now(),
      );

      expect(request.status, equals(TransferStatus.cancelled));
    });

    test('includes denormalized display fields', () {
      final request = OwnershipTransferRequest(
        id: 'transfer-1',
        calendarId: 'cal-1',
        calendarName: 'My Calendar',
        fromUid: 'user-1',
        toUid: 'user-2',
        createdAt: DateTime.now(),
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

  group('OwnershipTransferRequest isPending', () {
    test('returns true for pending status', () {
      final request = OwnershipTransferRequest(
        id: 'transfer-1',
        calendarId: 'cal-1',
        calendarName: 'My Calendar',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: TransferStatus.pending,
        createdAt: DateTime.now(),
      );

      expect(request.isPending, isTrue);
    });

    test('returns false for accepted status', () {
      final request = OwnershipTransferRequest(
        id: 'transfer-1',
        calendarId: 'cal-1',
        calendarName: 'My Calendar',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: TransferStatus.accepted,
        createdAt: DateTime.now(),
      );

      expect(request.isPending, isFalse);
    });

    test('returns false for declined status', () {
      final request = OwnershipTransferRequest(
        id: 'transfer-1',
        calendarId: 'cal-1',
        calendarName: 'My Calendar',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: TransferStatus.declined,
        createdAt: DateTime.now(),
      );

      expect(request.isPending, isFalse);
    });

    test('returns false for cancelled status', () {
      final request = OwnershipTransferRequest(
        id: 'transfer-1',
        calendarId: 'cal-1',
        calendarName: 'My Calendar',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: TransferStatus.cancelled,
        createdAt: DateTime.now(),
      );

      expect(request.isPending, isFalse);
    });
  });

  group('OwnershipTransferRequest JSON serialization', () {
    test('serializes to JSON', () {
      final now = DateTime.now().toUtc();

      final request = OwnershipTransferRequest(
        id: 'transfer-1',
        calendarId: 'cal-1',
        calendarName: 'My Calendar',
        fromUid: 'user-1',
        toUid: 'user-2',
        status: TransferStatus.pending,
        createdAt: now,
        fromDisplayName: 'Alice',
      );

      final json = request.toJson();

      expect(json['id'], equals('transfer-1'));
      expect(json['calendarId'], equals('cal-1'));
      expect(json['calendarName'], equals('My Calendar'));
      expect(json['fromUid'], equals('user-1'));
      expect(json['toUid'], equals('user-2'));
      expect(json['status'], equals('pending'));
      expect(json['fromDisplayName'], equals('Alice'));
    });

    test('deserializes from JSON', () {
      final now = DateTime.now().toUtc();

      final json = {
        'id': 'transfer-1',
        'calendarId': 'cal-1',
        'calendarName': 'My Calendar',
        'fromUid': 'user-1',
        'toUid': 'user-2',
        'status': 'pending',
        'createdAt': now.toIso8601String(),
        'fromDisplayName': 'Alice',
      };

      final request = OwnershipTransferRequest.fromJson(json);

      expect(request.id, equals('transfer-1'));
      expect(request.calendarId, equals('cal-1'));
      expect(request.calendarName, equals('My Calendar'));
      expect(request.fromUid, equals('user-1'));
      expect(request.toUid, equals('user-2'));
      expect(request.status, equals(TransferStatus.pending));
      expect(request.fromDisplayName, equals('Alice'));
    });

    test('deserializes status enum correctly', () {
      final now = DateTime.now().toUtc();

      final pendingJson = {
        'id': 't1',
        'calendarId': 'cal-1',
        'calendarName': 'Calendar',
        'fromUid': 'u1',
        'toUid': 'u2',
        'status': 'pending',
        'createdAt': now.toIso8601String(),
      };

      final acceptedJson = {
        'id': 't2',
        'calendarId': 'cal-1',
        'calendarName': 'Calendar',
        'fromUid': 'u1',
        'toUid': 'u2',
        'status': 'accepted',
        'createdAt': now.toIso8601String(),
      };

      final declinedJson = {
        'id': 't3',
        'calendarId': 'cal-1',
        'calendarName': 'Calendar',
        'fromUid': 'u1',
        'toUid': 'u2',
        'status': 'declined',
        'createdAt': now.toIso8601String(),
      };

      final cancelledJson = {
        'id': 't4',
        'calendarId': 'cal-1',
        'calendarName': 'Calendar',
        'fromUid': 'u1',
        'toUid': 'u2',
        'status': 'cancelled',
        'createdAt': now.toIso8601String(),
      };

      expect(
        OwnershipTransferRequest.fromJson(pendingJson).status,
        equals(TransferStatus.pending),
      );
      expect(
        OwnershipTransferRequest.fromJson(acceptedJson).status,
        equals(TransferStatus.accepted),
      );
      expect(
        OwnershipTransferRequest.fromJson(declinedJson).status,
        equals(TransferStatus.declined),
      );
      expect(
        OwnershipTransferRequest.fromJson(cancelledJson).status,
        equals(TransferStatus.cancelled),
      );
    });
  });
}
