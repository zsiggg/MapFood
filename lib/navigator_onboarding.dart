import 'package:flutter/material.dart';
import 'package:myapp/onboarding/login_screen.dart';
import 'package:myapp/onboarding/register_screen.dart';

class NavigatorOnboarding extends StatelessWidget {
  const NavigatorOnboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
              settings: settings,
            );
          case '/register':
            return MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
                settings: settings);
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
      },
    );
  }
}
