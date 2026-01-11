// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'platform_utils.dart';

/// Platform-adaptive text field that renders as CupertinoTextField on iOS/macOS
/// and Material TextField on other platforms.
class AdaptiveTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final String? labelText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final int? maxLength;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextInputAction? textInputAction;

  const AdaptiveTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.labelText,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.keyboardType,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    if (isApplePlatform) {
      return CupertinoTextField(
        controller: controller,
        placeholder: placeholder ?? labelText,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        obscureText: obscureText,
        keyboardType: keyboardType,
        readOnly: readOnly,
        maxLength: maxLength,
        maxLines: maxLines,
        suffix: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: suffixIcon,
              )
            : null,
        prefix: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: prefixIcon,
              )
            : null,
        onTap: onTap,
        focusNode: focusNode,
        autofocus: autofocus,
        textInputAction: textInputAction,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.systemGrey4),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: placeholder,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        counterText: maxLength != null ? null : '',
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLength: maxLength,
      maxLines: maxLines,
      onTap: onTap,
      focusNode: focusNode,
      autofocus: autofocus,
      textInputAction: textInputAction,
    );
  }
}

/// Platform-adaptive search field.
class AdaptiveSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final bool autofocus;

  const AdaptiveSearchField({
    super.key,
    this.controller,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isApplePlatform) {
      return CupertinoSearchTextField(
        controller: controller,
        placeholder: placeholder ?? 'Search',
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onSuffixTap: onClear,
        focusNode: focusNode,
        autofocus: autofocus,
      );
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: placeholder ?? 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }
}
