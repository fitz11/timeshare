// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

/// A widget that constrains its child to a maximum width and centers it.
///
/// Useful for preventing content from stretching too wide on large screens.
class ConstrainedContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ConstrainedContent({
    super.key,
    required this.child,
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
