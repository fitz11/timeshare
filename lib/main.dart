import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/auth_gate.dart';
import 'package:timeshare/ui/core/home_scaffold.dart';
import 'package:timeshare/ui/pages/auth.dart';
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
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      routes: {
        '/home': (context) => HomeScaffold(),
        '/login': (context) => AuthScreen(),
      },
      home: const AuthGate(),
    );
  }
}
