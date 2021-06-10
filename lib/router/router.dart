import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/router/route.dart';
import 'package:applithium_core/router/route_result.dart';
import 'package:flutter/widgets.dart';

import 'route_details.dart';

abstract class AplRouter {
  void applyRoute(AplRoute route);
}

abstract class MainRouter extends AplRouter {

  abstract final List<RouteDescription> routes;

  final GlobalKey<NavigatorState> _navigationKey;

  MainRouter(this._navigationKey);

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final result = evaluate(settings);
    if (!result.isMatch) {
      return null;
    }

    return result.build();
  }

  void _backWithResult(dynamic result) {
    _navigationKey.currentState?.pop(result);
  }

  @override
  void applyRoute(AplRoute route) {
    if(route is Back) {
      _backWithResult(route.result);
    } else {
      _navigationKey.currentState?.pushNamed(route.url);
    }
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

  RouterWithDialogs<M> withDialogs<M> (Future<dynamic> Function(M) dialogBuilder) {
    return RouterWithDialogs(dialogBuilder, this);
  }
}

class RouterWithDialogs<M> extends AplRouter {

  final Future<dynamic> Function(M) dialogBuilder;
  final MainRouter parentRouter;

  RouterWithDialogs(this.dialogBuilder, this.parentRouter);
  
  void openDialog(BaseBloc from, M model) {
    applyRoute(OpenDialog(model, (result) => from.add(BaseEvents.dialogClosed(model, result))));
  }

  @override
  void applyRoute(AplRoute route) {
    if(route is OpenDialog<M>) {
      dialogBuilder.call(route.model)
          .then((result) => route.notifyDialogClosed(result));
    } else {
      parentRouter.applyRoute(route);
    }
  }
}