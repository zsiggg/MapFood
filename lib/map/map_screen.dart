import 'package:flutter/material.dart';
import 'package:myapp/app_drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: const Center(
        child: Text('A map of locations'),
      ),
      drawer: const AppDrawer(),
    );
  }
}
