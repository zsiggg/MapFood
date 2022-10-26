import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/add/add_screen.dart';
import 'package:myapp/app_drawer.dart';
import 'package:myapp/auth/login_screen.dart';
import 'package:myapp/list/list_screen.dart';
import 'package:myapp/map/map_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/widget_tree.dart';
import 'firebase_options.dart';
import 'package:myapp/auth/auth.dart';
import 'package:myapp/home.dart';
import 'package:myapp/auth/register_screen.dart';

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

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MapFood",
      home: const WidgetTree(),
      routes: {
        '/add': (context) => const AddScreen(),
        '/list': (context) => const ListScreen(),
        '/map': (context) => MapSample(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const WidgetTree(),
      },
    );
  }
}
