import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/navigator_main.dart';
import 'package:myapp/navigator_onboarding.dart';
import 'firebase_options.dart';
import 'package:myapp/onboarding/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        Widget navigator;

        // if user is not logged in, display login screen
        if (snapshot.hasData) {
          navigator = const NavigatorMain();
        } else {
          navigator = const NavigatorOnboarding();
        }

        return MaterialApp(
          title: "MapFood",
          home: navigator,
        );
      },
    );
  }
}
