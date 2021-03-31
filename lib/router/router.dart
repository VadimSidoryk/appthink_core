import 'package:applithium_core/router/route.dart';
import 'package:flutter/cupertino.dart';

abstract class AplRouter<R> {
  void applyRoute(R model);
}

class MainRouter extends AplRouter<AplRoute> {

  String startRoute;
  Map<String, Widget Function(BuildContext)> routes;

  final GlobalKey<NavigatorState> _navigationKey;

  MainRouter(this._navigationKey);

  void _backWithResult(bool result) {
    _navigationKey.currentState.pop(result);
  }
  
  static T getArgs<T>(BuildContext context) {
    return ModalRoute.of(context).settings.arguments as T;
  }

  @override
  void applyRoute(AplRoute route) {
    if(route is Back) {
      _backWithResult(route.result);
    } else if(route is Push){
      _navigationKey.currentState.pushNamed(route.name, arguments: route.arguments);
    }
  }
}