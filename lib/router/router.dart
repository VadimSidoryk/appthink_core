import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/router/route.dart';
import 'package:flutter/widgets.dart';

abstract class AplRouter {
  void applyRoute(AplRoute route);
}

abstract class MainRouter extends AplRouter {

  abstract String startRoute;
  abstract final Map<String, Widget Function(BuildContext)> routes;

  final GlobalKey<NavigatorState> _navigationKey;

  MainRouter(this._navigationKey);

  void _backWithResult(dynamic result) {
    _navigationKey.currentState?.pop(result);
  }
  
  static T? getArgs<T>(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments as T?;
  }

  @override
  void applyRoute(AplRoute route) {
    if(route is Back) {
      _backWithResult(route.result);
    } else if(route is PushScreen){
      _navigationKey.currentState?.pushNamed(route.name, arguments: route.arguments);
    } else {
      logError("MainRoute can't handle this type of route");
    }
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