// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'platform_utils.dart';

/// Platform-adaptive button that renders as Cupertino on iOS/macOS
/// and Material on Android/Windows/Linux/Web.
class AdaptiveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const AdaptiveButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isPrimary = true,
  });

  /// Creates a primary (filled) button.
  const AdaptiveButton.primary({
    super.key,
    required this.child,
    this.onPressed,
  }) : isPrimary = true;

  /// Creates a secondary (outlined) button.
  const AdaptiveButton.secondary({
    super.key,
    required this.child,
    this.onPressed,
  }) : isPrimary = false;

  @override
  Widget build(BuildContext context) {
    if (isApplePlatform) {
      return isPrimary
          ? CupertinoButton.filled(onPressed: onPressed, child: child)
          : CupertinoButton(onPressed: onPressed, child: child);
    }
    return isPrimary
        ? FilledButton(onPressed: onPressed, child: child)
        : OutlinedButton(onPressed: onPressed, child: child);
  }
}

/// Platform-adaptive text button.
class AdaptiveTextButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const AdaptiveTextButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isApplePlatform) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: child,
      );
    }
    return TextButton(onPressed: onPressed, child: child);
  }
}

/// Platform-adaptive icon button.
class AdaptiveIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  const AdaptiveIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    if (isApplePlatform) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: icon,
      );
    }
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
