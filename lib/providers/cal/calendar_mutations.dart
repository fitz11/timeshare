// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:timeshare/data/exceptions/conflict_exception.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/repo/calendar_repo.dart';
import 'package:timeshare/providers/cal/calendar_stream_providers.dart';
import 'package:timeshare/providers/cal/events_stream_providers.dart';
import 'package:timeshare/providers/cal/optimistic_providers.dart';
import 'package:timeshare/providers/cal/repository_providers.dart';
import 'package:timeshare/providers/cal/selection_providers.dart';

const _uuid = Uuid();

/// Result of an optimistic mutation operation.
class MutationResult<T> {
  final T? data;
  final String? error;

  const MutationResult.success(this.data) : error = null;
  const MutationResult.failure(this.error) : data = null;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;
}

/// Calendar mutations with optimistic update support.
/// Includes conflict detection and retry mechanisms for concurrent edit handling.
class CalendarMutations extends Notifier<void> {
  CalendarRepository get _repo => ref.read(calendarRepositoryProvider);

  @override
  void build() {
    ref.keepAlive();
  }

  /// Add calendar with optimistic UI update.
  Future<MutationResult<Calendar>> addCalendarOptimistic({
    required String ownerUid,
    required String name,
  }) async {
    final calendar = Calendar(
      id: '${ownerUid}_$name',
      owner: ownerUid,
      name: name,
    );

    ref.read(optimisticCalendarsProvider.notifier).addPending(calendar);
    ref.read(selectedCalendarIdsProvider.notifier).toggle(calendar.id);

    try {
      await _repo.createCalendar(calendar);
      ref.read(optimisticCalendarsProvider.notifier).removePending(calendar.id);
      ref.invalidate(calendarsProvider);
      return MutationResult.success(calendar);
    } catch (e) {
      ref.read(optimisticCalendarsProvider.notifier).removePending(calendar.id);
      ref.read(selectedCalendarIdsProvider.notifier).toggle(calendar.id);
      return MutationResult.failure('Failed to create calendar: $e');
    }
  }

  /// Add event with optimistic UI update.
  Future<MutationResult<Event>> addEventOptimistic({
    required String calendarId,
    required Event event,
  }) async {
    final eventToAdd = event.copyWith(
      id: event.id.isEmpty ? _uuid.v4() : event.id,
      calendarId: calendarId,
    );

    ref.read(optimisticEventsProvider.notifier).addPending(eventToAdd);

    try {
      final created = await _repo.addEvent(calendarId, eventToAdd);
      // Explicitly remove pending since server may assign a different ID
      ref.read(optimisticEventsProvider.notifier).removePending(eventToAdd.id);
      ref.invalidate(eventsForSelectedCalendarsProvider);
      return MutationResult.success(created);
    } catch (e) {
      ref.read(optimisticEventsProvider.notifier).removePending(eventToAdd.id);
      return MutationResult.failure('Failed to create event: $e');
    }
  }

  /// Delete calendar with optimistic UI update.
  Future<MutationResult<void>> deleteCalendarOptimistic(String calendarId) async {
    ref.read(optimisticCalendarsProvider.notifier).addDeleting(calendarId);
    final wasSelected = ref.read(selectedCalendarIdsProvider).contains(calendarId);
    if (wasSelected) {
      ref.read(selectedCalendarIdsProvider.notifier).toggle(calendarId);
    }

    try {
      await _repo.deleteCalendar(calendarId);
      ref.read(optimisticCalendarsProvider.notifier).removeDeleting(calendarId);
      return const MutationResult.success(null);
    } catch (e) {
      ref.read(optimisticCalendarsProvider.notifier).removeDeleting(calendarId);
      if (wasSelected) {
        ref.read(selectedCalendarIdsProvider.notifier).toggle(calendarId);
      }
      return MutationResult.failure('Failed to delete calendar: $e');
    }
  }

  /// Delete event with optimistic UI update.
  Future<MutationResult<void>> deleteEventOptimistic({
    required String calendarId,
    required String eventId,
  }) async {
    ref.read(optimisticEventsProvider.notifier).addDeleting(eventId);

    try {
      await _repo.deleteEvent(calendarId, eventId);
      ref.read(optimisticEventsProvider.notifier).removeDeleting(eventId);
      return const MutationResult.success(null);
    } catch (e) {
      ref.read(optimisticEventsProvider.notifier).removeDeleting(eventId);
      return MutationResult.failure('Failed to delete event: $e');
    }
  }

  // Legacy methods kept for compatibility
  Future<void> addCalendar({
    required String ownerUid,
    required String name,
  }) async {
    final calendar = Calendar(
      id: _uuid.v4(),
      owner: ownerUid,
      name: name,
    );
    await _repo.createCalendar(calendar);
  }

  Future<Event> addEvent({
    required String calendarId,
    required Event event,
  }) async {
    final eventToAdd = event.id.isEmpty
        ? event.copyWith(id: _uuid.v4())
        : event;
    return await _repo.addEvent(calendarId, eventToAdd);
  }

  Future<Event> updateEvent({
    required String calendarId,
    required Event event,
  }) =>
      _repo.updateEvent(calendarId, event);

  /// Update event with optimistic update and conflict handling.
  Future<Event> updateEventOptimistic({
    required String calendarId,
    required Event event,
    void Function(ConflictException)? onConflict,
  }) async {
    ref.read(optimisticEventsProvider.notifier).updatePending(event);

    try {
      final updatedEvent = await _repo.updateEvent(calendarId, event);
      // Explicitly remove pending for consistency with addEventOptimistic
      ref.read(optimisticEventsProvider.notifier).removePending(event.id);
      ref.invalidate(eventsForSelectedCalendarsProvider);
      return updatedEvent;
    } on ConflictException catch (e) {
      ref.read(optimisticEventsProvider.notifier).removePending(event.id);
      onConflict?.call(e);
      ref.invalidate(eventsForSelectedCalendarsProvider);
      rethrow;
    } catch (e) {
      ref.read(optimisticEventsProvider.notifier).removePending(event.id);
      rethrow;
    }
  }

  /// Retry an event update with server data as the base.
  Future<Event> retryEventUpdateWithMerge({
    required String calendarId,
    required Event localEvent,
    required Event serverEvent,
    required Event Function(Event local, Event server) mergeStrategy,
  }) async {
    final mergedEvent = mergeStrategy(localEvent, serverEvent);
    return await _repo.updateEvent(calendarId, mergedEvent);
  }

  /// Update calendar with optimistic update and conflict handling.
  Future<Calendar> updateCalendar({
    required Calendar calendar,
    void Function(ConflictException)? onConflict,
  }) async {
    ref.read(optimisticCalendarsProvider.notifier).updatePending(calendar);

    try {
      final updatedCalendar = await _repo.updateCalendar(calendar);
      ref.read(optimisticCalendarsProvider.notifier).removePending(calendar.id);
      return updatedCalendar;
    } on ConflictException catch (e) {
      ref.read(optimisticCalendarsProvider.notifier).removePending(calendar.id);
      onConflict?.call(e);
      ref.invalidate(calendarsProvider);
      rethrow;
    } catch (e) {
      ref.read(optimisticCalendarsProvider.notifier).removePending(calendar.id);
      rethrow;
    }
  }

  Future<void> deleteEvent({
    required String calendarId,
    required String eventId,
  }) =>
      _repo.deleteEvent(calendarId, eventId);

  Future<void> deleteCalendar(String calendarId) =>
      _repo.deleteCalendar(calendarId);

  Future<void> shareCalendar(
    String calendarId,
    String targetUid,
    bool share,
  ) =>
      _repo.shareCalendar(calendarId, targetUid, share);
}

final calendarMutationsProvider = NotifierProvider<CalendarMutations, void>(
  CalendarMutations.new,
);
