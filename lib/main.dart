import 'package:flutter/material.dart';
import 'package:myapp/add/add_screen.dart';
import 'package:myapp/app_drawer.dart';
import 'package:myapp/auth/login_screen.dart';
import 'package:myapp/list/list_screen.dart';
import 'package:myapp/map/map_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:myapp/auth/auth.dart';
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
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            title: "MapFood",
            home: Scaffold(
              appBar: AppBar(title: const Text('MapFood')),
              drawer: const AppDrawer(),
            ),
            routes: {
              '/add': (context) => const AddScreen(),
              '/list': (context) => const ListScreen(),
              '/map': (context) => MapSample(),
            },
          );
        } else {
          return MaterialApp(
            title: 'MapFood',
            home: const LoginScreen(),
            routes: {
              '/register': (context) => const RegisterScreen(),
            },
          );
        }
      },
    );
  }
}
