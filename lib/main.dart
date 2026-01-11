// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/auth_gate.dart';
import 'package:timeshare/ui/shell/home_scaffold.dart';
import 'package:timeshare/ui/features/auth/auth_screen.dart';
import 'package:timeshare/ui/core/theme/themes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
