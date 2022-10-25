import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/add/add_screen.dart';
import 'package:myapp/app_drawer.dart';
import 'package:myapp/list/list_screen.dart';
import 'package:myapp/map/map_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:myapp/auth/auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "MapFood",
        home: Scaffold(
          appBar: AppBar(title: const Text("MapFood")),
          drawer: const AppDrawer(),
        ),
        routes: {
          '/add': (context) => const AddScreen(),
          '/list': (context) => const ListScreen(),
          '/map': (context) => MapSample(),
        });
  }
}
