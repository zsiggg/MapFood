import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/add/add_screen.dart';
import 'package:myapp/list/list_screen.dart';
import 'package:myapp/map/map_screen.dart';

class AppDrawer extends Drawer {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Icon(Icons.person)),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Add"),
            onTap: () {
              Navigator.pushNamed(context, '/add');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text("Reviews"),
            onTap: () {
              Navigator.pushNamed(context, '/list');
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text("Map"),
            onTap: () {
              Navigator.pushNamed(context, '/map');
            },
          ),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log out"),
              onTap: () async {
                // workaround for using BuildContext across async gaps error
                final NavigatorState navigator = Navigator.of(context);

                try {
                  await FirebaseAuth.instance.signOut();
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                            e.message ?? 'An error occurred while logging out'),
                      ),
                    );
                  return;
                }

                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Logged out'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                navigator.pushNamed('/');
              }),
        ],
      ),
    );
  }
}
