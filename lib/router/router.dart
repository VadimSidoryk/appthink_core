import 'package:applithium_core/router/route.dart';
import 'package:flutter/cupertino.dart';

class AplRouter {

  String startRoute;
  Map<String, Widget Function(BuildContext)> routes;
  
  final GlobalKey<NavigatorState> _navigationKey;

  AplRouter(this._navigationKey);

  void _back() {
    _navigationKey.currentState.pop();
  }

  static T getArgs<T>(BuildContext context) {
    return ModalRoute.of(context).settings.arguments as T;
  }

  void applyRoute(AplRoute route) {
    if(route is Back) {
      _back();
    } else {
      _navigationKey.currentState.pushNamed(route.name, arguments: route.arguments);
    }
  }
}