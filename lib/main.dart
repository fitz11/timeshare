import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timeshare/util.dart';
import 'package:timeshare/pages/calendarview.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const Timeshare());
}

class Timeshare extends StatelessWidget {
  const Timeshare({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];
    void onSignedIn() {
      Navigator.pushReplacementNamed(context, '/calendarview');
    }

    return MaterialApp(
      title: 'TimeShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            actions: [
              AuthStateChangeAction<UserCreated>((context, state) {
                onSignedIn();
              }),
              AuthStateChangeAction<SignedIn>((context, state) {
                onSignedIn();
              }),
            ],
          );
        },
      },
      home: CalendarView(calendars: [testCalendar]),
    );
  }
}
