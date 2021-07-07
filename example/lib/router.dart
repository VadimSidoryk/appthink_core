import 'package:applithium_core/router/matchers.dart';
import 'package:applithium_core/router/route_details.dart';
import 'package:applithium_core/router/router.dart';
import 'package:applithium_core/scopes/scope.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core_example/page/data.dart';
import 'package:applithium_core_example/page/domain.dart';
import 'package:flutter/widgets.dart';

import 'page/presentation.dart';

class MyRouter extends MainRouter {

  static const String _ROUTE_MAIN = "/main";

  @override
  String startRoute = _ROUTE_MAIN;

  @override
  get routes => [
    RouteDetails(
      builder: (context, result) => Scope(child: MyScreen(), store: _getMyDependencies(context)),
      subRoutes: [
        RouteDetails(
          matcher: Matcher.path("details/{productId}"),
          builder: (context, result) {
            final id = result.parameters["productId"];
            throw StateError("invalid path");
          }
        )
      ]
    )
  ];

  MyRouter(GlobalKey<NavigatorState> navigationKey) : super(navigationKey);

  Store _getMyDependencies(BuildContext context) {
    return Store()..add((provider) => MyUseCaseImpl())
        ..add((provider) => MyRepository(useCase: provider.get<MyUseCaseImpl>()));
  }
}