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
    RouteDescription(
      matcher: Matcher.host("http://applithium.com"),
      builder: (context, result) => Scope(child: MyScreen(), store: _getMyDependencies(context)),
      subRoutes: [
        RouteDescription(
          matcher: Matcher.path("details/{productId}"),
          builder: (context, result) {
            final id = result.parameters["productId"];
            throw StateError("invalid path");
          }
        )
      ]
    ),
    RouteDescription(
      builder: (context, result) => throw StateError("invalid host")
    )
  ];

  MyRouter(GlobalKey<NavigatorState> navigationKey) : super(navigationKey);

  Store _getMyDependencies(BuildContext context) {
    return Store()..add((provider) => MyUseCaseImpl())
        ..add((provider) => MyRepository(useCase: provider.get<MyUseCaseImpl>()))
        ..add((provider) => MyBloc(provider.get<MyRepository>()));
  }


}