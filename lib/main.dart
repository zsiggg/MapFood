import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/add/add_screen.dart';
import 'package:myapp/app_drawer.dart';
import 'package:myapp/list/list_screen.dart';
import 'package:myapp/map/map_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:myapp/auth.dart';

void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Auth().signInWithGoogle();
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
        home: Scaffold(
          appBar: AppBar(title: const Text("MapFood")),
          drawer: const AppDrawer(),
        ),
        initialRoute: '/add',
        routes: {
          '/add': (context) => const AddScreen(),
          '/list': (context) => const ListScreen(),
          '/map': (context) => MapSample(),
        });
  }
}
