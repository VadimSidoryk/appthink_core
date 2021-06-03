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
  get routes => {
    _ROUTE_MAIN: (context) => Scope(child: MyScreen(), store: _getMyDependencies(context))
  };

  MyRouter(GlobalKey<NavigatorState> navigationKey) : super(navigationKey);

  static Store _getMyDependencies(BuildContext context) {
    return Store()..add((provider) => MyUseCaseImpl())
        ..add((provider) => MyRepository(useCase: provider.get<MyUseCaseImpl>()))
        ..add((provider) => MyBloc(provider.get<MyRepository>()));
  }


}