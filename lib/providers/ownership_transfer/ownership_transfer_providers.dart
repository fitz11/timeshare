// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/models/ownership_transfer/ownership_transfer_request.dart';
import 'package:timeshare/data/repo/ownership_transfer_repo.dart';
import 'package:timeshare/data/repo/rest_api_ownership_transfer_repo.dart';
import 'package:timeshare/data/repo/logged_ownership_transfer_repo.dart';
import 'package:timeshare/data/services/api_client.dart';
import 'package:timeshare/providers/auth/auth_providers.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/providers/config/config_providers.dart';

/// Ownership transfer repository provider - uses REST API.
final ownershipTransferRepositoryProvider =
    Provider<OwnershipTransferRepository>((ref) {
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
});

/// Stream of incoming ownership transfer requests (polling-based).
final incomingOwnershipTransfersProvider =
    StreamProvider<List<OwnershipTransferRequest>>((ref) {
  ref.keepAlive();

  ref.listen(authStateProvider, (prev, next) {
    ref.invalidateSelf();
  });

  final repo = ref.watch(ownershipTransferRepositoryProvider);
  return repo.watchIncomingTransfers();
});

/// Future of sent ownership transfer requests.
final sentOwnershipTransfersProvider =
    FutureProvider<List<OwnershipTransferRequest>>((ref) async {
  ref.listen(authStateProvider, (prev, next) {
    ref.invalidateSelf();
  });

  final repo = ref.watch(ownershipTransferRepositoryProvider);
  return repo.getSentTransfers();
});

/// Count of pending incoming transfer requests (for badge display).
final pendingTransferCountProvider = Provider<int>((ref) {
  final transfersAsync = ref.watch(incomingOwnershipTransfersProvider);
  final transfers = transfersAsync.value ?? [];
  return transfers.where((t) => t.isPending).length;
});

/// Ownership transfer mutations notifier.
class OwnershipTransferNotifier extends Notifier<void> {
  OwnershipTransferRepository get _repo =>
      ref.read(ownershipTransferRepositoryProvider);

  @override
  void build() {
    // No initial state needed
  }

  Future<OwnershipTransferRequest> requestTransfer({
    required String calendarId,
    required String toUid,
  }) async {
    final request = await _repo.requestTransfer(calendarId, toUid);
    ref.invalidate(sentOwnershipTransfersProvider);
    return request;
  }

  Future<void> acceptTransfer({required String requestId}) async {
    await _repo.acceptTransfer(requestId);
    ref.invalidate(calendarsProvider);
    ref.invalidate(incomingOwnershipTransfersProvider);
  }

  Future<void> declineTransfer({required String requestId}) async {
    await _repo.declineTransfer(requestId);
    ref.invalidate(incomingOwnershipTransfersProvider);
  }

  Future<void> cancelTransfer({required String requestId}) async {
    await _repo.cancelTransfer(requestId);
    ref.invalidate(sentOwnershipTransfersProvider);
  }
}

final ownershipTransferProvider =
    NotifierProvider<OwnershipTransferNotifier, void>(
  OwnershipTransferNotifier.new,
);
