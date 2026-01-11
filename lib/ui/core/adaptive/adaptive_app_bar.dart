// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'platform_utils.dart';

/// Platform-adaptive app bar that renders as CupertinoNavigationBar on iOS/macOS
/// and Material AppBar on other platforms.
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final bool centerTitle;

  const AdaptiveAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final titleContent = titleWidget ?? (title != null ? Text(title!) : null);

    if (isApplePlatform) {
      return CupertinoNavigationBar(
        middle: titleContent,
        trailing: actions != null && actions!.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              )
            : null,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: backgroundColor,
      );
    }

    return AppBar(
      title: titleContent,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        isApplePlatform ? 44.0 : kToolbarHeight,
      );
}

/// Platform-adaptive sliver app bar for use in CustomScrollView.
class AdaptiveSliverAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool pinned;
  final bool floating;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final bool automaticallyImplyLeading;

  const AdaptiveSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.pinned = false,
    this.floating = false,
    this.expandedHeight,
    this.flexibleSpace,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final titleContent = titleWidget ?? (title != null ? Text(title!) : null);

    if (isApplePlatform) {
      return CupertinoSliverNavigationBar(
        largeTitle: titleContent,
        trailing: actions != null && actions!.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              )
            : null,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
      );
    }

    return SliverAppBar(
      title: titleContent,
      actions: actions,
      leading: leading,
      pinned: pinned,
      floating: floating,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}
