import 'package:flutter/material.dart';
import 'package:myapp/add/add_screen.dart';
import 'package:myapp/app_drawer.dart';
import 'package:myapp/list/list_screen.dart';
import 'package:myapp/map/map_screen.dart';

void main() {
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
        home: Scaffold(
          appBar: AppBar(title: const Text("MapFood")),
          drawer: const AppDrawer(),
        ),
        initialRoute: '/add',
        routes: {
          '/add': (context) => const AddScreen(),
          '/list': (context) => const ListScreen(),
          '/map': (context) => const MapScreen(),
        });
  }
}
