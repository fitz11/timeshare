/// Platform-adaptive UI components that render Cupertino widgets on iOS/macOS
/// and Material widgets on Android/Windows/Linux/Web.
///
/// Usage:
/// ```dart
/// import 'package:timeshare/ui/core/adaptive/adaptive.dart';
///
/// // Use adaptive widgets throughout your app
/// AdaptiveButton(onPressed: () {}, child: Text('Click me'))
/// AdaptiveTextField(labelText: 'Name', onChanged: (s) {})
/// ```
library;

export 'platform_utils.dart';
export 'adaptive_app_bar.dart';
export 'adaptive_button.dart';
export 'adaptive_dialog.dart';
export 'adaptive_scaffold.dart';
export 'adaptive_text_field.dart';
