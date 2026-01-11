import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'platform_utils.dart';

/// Shows a platform-adaptive confirmation dialog.
/// Renders as CupertinoAlertDialog on iOS/macOS, AlertDialog on other platforms.
Future<bool?> showAdaptiveConfirmDialog({
  required BuildContext context,
  required String title,
  String? content,
  required String confirmText,
  String cancelText = 'Cancel',
  bool isDestructive = false,
}) {
  if (isApplePlatform) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: content != null ? Text(content) : null,
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          CupertinoDialogAction(
            isDestructiveAction: isDestructive,
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: content != null ? Text(content) : null,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText),
        ),
        isDestructive
            ? FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(confirmText),
              )
            : FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(confirmText),
              ),
      ],
    ),
  );
}

/// Shows a platform-adaptive dialog with custom content.
Future<T?> showAdaptiveDialog<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool barrierDismissible = true,
}) {
  if (isApplePlatform) {
    return showCupertinoDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: builder,
  );
}

/// Platform-adaptive alert dialog widget.
class AdaptiveAlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget> actions;

  const AdaptiveAlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (isApplePlatform) {
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: actions,
      );
    }
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }
}

/// Platform-adaptive dialog action button.
class AdaptiveDialogAction extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isDefaultAction;
  final bool isDestructiveAction;

  const AdaptiveDialogAction({
    super.key,
    required this.child,
    this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isApplePlatform) {
      return CupertinoDialogAction(
        isDefaultAction: isDefaultAction,
        isDestructiveAction: isDestructiveAction,
        onPressed: onPressed,
        child: child,
      );
    }

    if (isDestructiveAction) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
        ),
        child: child,
      );
    }

    return TextButton(
      onPressed: onPressed,
      child: child,
    );
  }
}

/// Shows a platform-adaptive action sheet (bottom sheet on Material,
/// CupertinoActionSheet on iOS).
Future<T?> showAdaptiveActionSheet<T>({
  required BuildContext context,
  String? title,
  String? message,
  required List<AdaptiveAction<T>> actions,
  AdaptiveAction<T>? cancelAction,
}) {
  if (isApplePlatform) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: title != null ? Text(title) : null,
        message: message != null ? Text(message) : null,
        actions: actions
            .map((action) => CupertinoActionSheetAction(
                  isDestructiveAction: action.isDestructive,
                  onPressed: () => Navigator.pop(context, action.value),
                  child: Text(action.label),
                ))
            .toList(),
        cancelButton: cancelAction != null
            ? CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context, cancelAction.value),
                child: Text(cancelAction.label),
              )
            : null,
      ),
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(message),
            ),
          ...actions.map((action) => ListTile(
                title: Text(
                  action.label,
                  style: action.isDestructive
                      ? TextStyle(color: Theme.of(context).colorScheme.error)
                      : null,
                ),
                onTap: () => Navigator.pop(context, action.value),
              )),
          if (cancelAction != null)
            ListTile(
              title: Text(cancelAction.label),
              onTap: () => Navigator.pop(context, cancelAction.value),
            ),
        ],
      ),
    ),
  );
}

/// Represents an action in an adaptive action sheet.
class AdaptiveAction<T> {
  final String label;
  final T value;
  final bool isDestructive;

  const AdaptiveAction({
    required this.label,
    required this.value,
    this.isDestructive = false,
  });
}
