// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/auth_gate.dart';
import 'package:timeshare/services/logging/app_logger.dart';
import 'package:timeshare/ui/shell/home_scaffold.dart';
import 'package:timeshare/ui/features/auth/auth_screen.dart';
import 'package:timeshare/ui/core/theme/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the app logger
  await AppLogger().initialize();

  runApp(const ProviderScope(child: Timeshare()));
}

class Timeshare extends ConsumerWidget {
  const Timeshare({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'TimeShare',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(lightColorScheme, Brightness.light),
      darkTheme: buildTheme(darkColorScheme, Brightness.dark),
      themeMode: ThemeMode.system,
      routes: {
        '/home': (context) => const HomeScaffold(),
        '/login': (context) => const AuthScreen(),
      },
      home: const AuthGate(),
    );
  }
}
