// SPDX-License-Identifier: AGPL-3.0-or-later

/// Get initials from a display name (e.g., "John Doe" -> "JD")
/// Returns at most 2 characters, uppercase.
String getInitials(String displayName) {
  return displayName
      .split(' ')
      .map((n) => n.isNotEmpty ? n[0].toUpperCase() : '')
      .take(2)
      .join();
}
