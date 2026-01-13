// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeshare/data/models/ownership_transfer/ownership_transfer_request.dart';
import 'package:timeshare/data/repo/ownership_transfer_repo.dart';
import 'package:timeshare/data/repo/rest_api_ownership_transfer_repo.dart';
import 'package:timeshare/data/repo/logged_ownership_transfer_repo.dart';
import 'package:timeshare/data/services/api_client.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/providers/config/config_providers.dart';

part 'ownership_transfer_providers.g.dart';

/// Ownership transfer repository provider - uses REST API
@riverpod
OwnershipTransferRepository ownershipTransferRepository(Ref ref) {
  final config = ref.watch(appConfigProvider);
  final authService = ref.watch(authServiceProvider);
  final logger = ref.watch(appLoggerProvider);

  final apiClient = HttpApiClient(
    baseUrl: config.apiBaseUrl,
    getApiKey: () => authService.apiKey,
  );

  return LoggedOwnershipTransferRepository(
    RestApiOwnershipTransferRepository(client: apiClient),
    logger,
  );
}

/// Stream of incoming ownership transfer requests (polling-based).
@riverpod
Stream<List<OwnershipTransferRequest>> incomingOwnershipTransfers(Ref ref) {
  ref.keepAlive();

  // Invalidate when auth state changes
  ref.listen(authStateProvider, (prev, next) {
    ref.invalidateSelf();
  });

  final repo = ref.watch(ownershipTransferRepositoryProvider);
  return repo.watchIncomingTransfers();
}

/// Future of sent ownership transfer requests.
@riverpod
Future<List<OwnershipTransferRequest>> sentOwnershipTransfers(Ref ref) async {
  // Invalidate when auth state changes
  ref.listen(authStateProvider, (prev, next) {
    ref.invalidateSelf();
  });

  final repo = ref.watch(ownershipTransferRepositoryProvider);
  return repo.getSentTransfers();
}

/// Count of pending incoming transfer requests (for badge display).
@riverpod
int pendingTransferCount(Ref ref) {
  final transfersAsync = ref.watch(incomingOwnershipTransfersProvider);
  final transfers = transfersAsync.value ?? [];
  return transfers.where((t) => t.isPending).length;
}

/// Ownership transfer mutations notifier.
@riverpod
class OwnershipTransferNotifier extends _$OwnershipTransferNotifier {
  OwnershipTransferRepository get _repo =>
      ref.read(ownershipTransferRepositoryProvider);

  @override
  void build() {
    // No initial state needed
  }

  /// Request to transfer ownership of a calendar.
  ///
  /// Only the calendar owner can initiate a transfer.
  Future<OwnershipTransferRequest> requestTransfer({
    required String calendarId,
    required String toUid,
  }) async {
    final request = await _repo.requestTransfer(calendarId, toUid);
    ref.invalidate(sentOwnershipTransfersProvider);
    return request;
  }

  /// Accept a transfer request, becoming the new owner.
  Future<void> acceptTransfer({required String requestId}) async {
    await _repo.acceptTransfer(requestId);
    // Refresh calendars (ownership changed) and transfers
    ref.invalidate(calendarsProvider);
    ref.invalidate(incomingOwnershipTransfersProvider);
  }

  /// Decline a transfer request.
  Future<void> declineTransfer({required String requestId}) async {
    await _repo.declineTransfer(requestId);
    ref.invalidate(incomingOwnershipTransfersProvider);
  }

  /// Cancel a sent transfer request.
  Future<void> cancelTransfer({required String requestId}) async {
    await _repo.cancelTransfer(requestId);
    ref.invalidate(sentOwnershipTransfersProvider);
  }
}
