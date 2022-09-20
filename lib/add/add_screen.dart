import 'package:flutter/material.dart';
import 'package:myapp/add/add_widget.dart';
import 'package:myapp/app_drawer.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add review')),
      body: const AddWidget(),
      drawer: const AppDrawer(),
    );
  }
}
