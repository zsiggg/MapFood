import 'package:flutter/material.dart';
import 'package:myapp/auth/auth.dart';
import 'package:myapp/auth/login_screen.dart';
import 'package:myapp/home.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTree();
}

class _WidgetTree extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Home();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
