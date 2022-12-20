import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key, required this.navigatorKey}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      switch (index) {
        case 0:
          widget.navigatorKey.currentState
              ?.pushNamedAndRemoveUntil('add', (route) => false);
          break;
        case 1:
          widget.navigatorKey.currentState
              ?.pushNamedAndRemoveUntil('list', (route) => false);
          break;
        case 2:
          widget.navigatorKey.currentState
              ?.pushNamedAndRemoveUntil('map', (route) => false);
          break;
        case 3:
          // widget.navigatorKey.currentState
          //     ?.pushNamedAndRemoveUntil('settings', (route) => false);
          FirebaseAuth.instance.signOut();
          break;
      }
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}
