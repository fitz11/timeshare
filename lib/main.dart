// Timeshare: a cross-platform app to make and share calendars.
// Copyright (C) 2025  David Fitzsimmons
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/auth_gate.dart';
import 'package:timeshare/ui/core/home_scaffold.dart';
import 'package:timeshare/ui/login/login_screen.dart';
import 'package:timeshare/ui/themes.dart';
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
