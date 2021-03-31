import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/router/route.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/widgets.dart';

abstract class AplRouter {
  void applyRoute(AplRoute route);
}

class MainRouter extends AplRouter {

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
    } else if(route is PushScreen){
      _navigationKey.currentState.pushNamed(route.name, arguments: route.arguments);
    } else {
      logError("MainRoute can't handle this type of route");
    }
  }

  DialogRouter<D> withDialogs<D extends OpenDialog> (Future<dynamic> Function(D) dialogBuilder) {
    return DialogRouter(dialogBuilder, this);
  }
}

class DialogRouter<M> extends AplRouter {

  final Future<dynamic> Function(M) dialogBuilder;
  final MainRouter parentRouter;

  DialogRouter(this.dialogBuilder, this.parentRouter);
  
  void openDialog(BaseBloc from, M model) {
    applyRoute(OpenDialog(model, from));
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