// SPDX-License-Identifier: AGPL-3.0-or-later

/// Breakpoint constants for responsive layouts.
abstract class Breakpoints {
  /// Width below which mobile layout is used.
  static const double mobile = 600;

  /// Width at or above which desktop layout is used.
  static const double tablet = 1200;
}

/// Screen size categories for responsive layouts.
enum ScreenSize { mobile, tablet, desktop }

/// Returns the appropriate screen size for the given width.
ScreenSize getScreenSize(double width) {
  if (width < Breakpoints.mobile) return ScreenSize.mobile;
  if (width < Breakpoints.tablet) return ScreenSize.tablet;
  return ScreenSize.desktop;
}
