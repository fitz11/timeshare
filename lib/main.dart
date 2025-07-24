import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/auth_gate.dart';
import 'package:timeshare/ui/home_frame.dart';
import 'package:timeshare/ui/pages/auth.dart';
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
    //here we define our available sign-in options (currently only email)

    return MaterialApp(
      title: 'TimeShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/home': (context) => HomeFrame(),
        '/login': (context) => AuthScreen(),
      },
      home: const AuthGate(),
    );
  }
}
