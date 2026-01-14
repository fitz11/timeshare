// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/data/models/event/event.dart';

/// Selected day in the calendar.
class SelectedDay extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

  void select(DateTime day) => state = normalizeDate(day);
  void clear() => state = null;
}

final selectedDayProvider = NotifierProvider<SelectedDay, DateTime?>(
  SelectedDay.new,
);

/// Focused day in the calendar widget (which month is displayed).
class FocusedDay extends Notifier<DateTime> {
  @override
  DateTime build() => normalizeDate(DateTime.now());

  void set(DateTime day) => state = normalizeDate(day);
}

final focusedDayProvider = NotifierProvider<FocusedDay, DateTime>(
  FocusedDay.new,
);

/// Calendar display format (month, two weeks, week).
class CalendarFormatState extends Notifier<CalendarFormat> {
  @override
  CalendarFormat build() => CalendarFormat.month;

  void set(CalendarFormat format) => state = format;
}

final calendarFormatStateProvider =
    NotifierProvider<CalendarFormatState, CalendarFormat>(
  CalendarFormatState.new,
);

/// Filter toggle - show only events after today.
class AfterTodayFilter extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}

final afterTodayFilterProvider = NotifierProvider<AfterTodayFilter, bool>(
  AfterTodayFilter.new,
);

/// Interaction mode (normal, copy, delete).
class InteractionModeState extends Notifier<InteractionMode> {
  @override
  InteractionMode build() => InteractionMode.normal;

  void setMode(InteractionMode mode) => state = mode;
  void setNormal() => state = InteractionMode.normal;
  void setCopy() => state = InteractionMode.copy;
  void setDelete() => state = InteractionMode.delete;
}

final interactionModeStateProvider =
    NotifierProvider<InteractionModeState, InteractionMode>(
  InteractionModeState.new,
);

/// Event being copied (when in copy mode).
class CopyEventState extends Notifier<Event?> {
  @override
  Event? build() {
    ref.keepAlive();
    return null;
  }

  void set(Event event) {
    state = event.copyWith();
  }

  void clear() {
    state = null;
  }
}

final copyEventStateProvider = NotifierProvider<CopyEventState, Event?>(
  CopyEventState.new,
);
