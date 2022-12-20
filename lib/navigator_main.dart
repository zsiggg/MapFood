import 'package:flutter/material.dart';
import 'package:myapp/add/add_widget.dart';
import 'package:myapp/map/map_widget.dart';
import 'package:myapp/navbar.dart';

class NavigatorMain extends StatefulWidget {
  const NavigatorMain({Key? key}) : super(key: key);

  @override
  State<NavigatorMain> createState() => _NavigatorMainState();
}

class _NavigatorMainState extends State<NavigatorMain>
    with TickerProviderStateMixin {
  FloatingActionButton? _floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();

    late final AnimationController controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.2,
    )..forward();
    late final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );

    MaterialPageRoute<void> onGenerateRoute(RouteSettings settings) {
      WidgetBuilder builder;
      switch (settings.name) {
        case 'add':
          builder = (context) => const AddWidget();
          break;
        case 'list':
          builder = (context) => const Center(
                child: Text('a list of reviews'),
              );
          break;
        case 'map':
          builder = (context) =>
              MapWidget(setFloatingActionButton: setFloatingActionButton);
          break;
        // case '/settings':
        //   print('To be implemented');
        //   break;
        default:
          throw Exception('Invalid route: ${settings.name}');
      }
      return MaterialPageRoute<void>(builder: builder, settings: settings);
    }

    return FadeTransition(
      opacity: animation,
      child: Scaffold(
        appBar: AppBar(title: const Text('MapFood')),
        body: Navigator(
          key: navigatorKey,
          initialRoute: 'add',
          onGenerateRoute: onGenerateRoute,
        ),
        bottomNavigationBar: NavBar(navigatorKey: navigatorKey),
        floatingActionButton: _floatingActionButton,
      ),
    );
  }

  void setFloatingActionButton(FloatingActionButton button) {
    setState(() {
      _floatingActionButton = button;
    });
  }
}
