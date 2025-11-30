// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

enum HomePages { profile, calendar, friends }

/// Represents the current interaction mode in the calendar UI
enum InteractionMode {
  /// Normal mode - no special interaction
  normal,

  /// Copy mode - allows copying events to selected dates
  copy,

  /// Delete mode - allows deleting events
  delete,
}
