import 'package:flutter/material.dart';
import 'package:myapp/app_drawer.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Past reviews')),
      body: const Center(
        child: Text('a list of locations'),
      ),
      drawer: const AppDrawer(),
    );
  }
}
