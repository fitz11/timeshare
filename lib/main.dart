import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/auth_gate.dart';
import 'package:timeshare/services/logging/app_logger.dart';
import 'package:timeshare/ui/shell/home_scaffold.dart';
import 'package:timeshare/ui/features/auth/auth_screen.dart';
import 'package:timeshare/ui/core/theme/themes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Crashlytics error handlers (release mode only)
  if (!kDebugMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Initialize the app logger
  await AppLogger().initialize();

  runApp(ProviderScope(child: Timeshare()));
}

class Timeshare extends ConsumerWidget {
  const Timeshare({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'TimeShare',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(lightColorScheme, Brightness.light),
      darkTheme: buildTheme(darkColorScheme, Brightness.dark),
      themeMode:
          ThemeMode.system, // Automatically switch based on system settings
      routes: {
        '/home': (context) => HomeScaffold(),
        '/login': (context) => AuthScreen(),
      },
      home: const AuthGate(),
    );
  }
}
