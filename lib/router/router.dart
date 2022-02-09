import 'package:flutter/widgets.dart';

import 'route_details.dart';
import 'route_result.dart';

class AplRouter {
  final List<RouteDetails> routes;
  final GlobalKey<NavigatorState> navigationKey;

  AplRouter({required this.navigationKey, required this.routes});

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final result = evaluate(settings);
    if (!result.isMatch) {
      return null;
    }

    return result.build();
  }

  void back([dynamic result]) {
    navigationKey.currentState?.pop(result);
  }

  void replace(String path) {
    navigationKey.currentState?.pushReplacementNamed(path);
  }

  void push(String path) {
    navigationKey.currentState?.pushNamed(path);
  }

  @protected
  RouteResult evaluate(RouteSettings settings) {
    assert(settings.name != null);
    final rootResult = RouteResult.root(settings);

    for (final route in routes) {
      final result = route.evaluate(rootResult);
      if (result.isMatch) {
        return result;
      }
    }
    return rootResult.withNoNestedMatch();
  }
}