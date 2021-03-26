import 'package:applithium_core/presentation/dialog.dart';
import 'package:applithium_core/router/route.dart';
import 'package:flutter/cupertino.dart';

abstract class AplRouter<R> {
  void applyRoute(R model);
}

class MainAplRouter extends AplRouter<AplRoute> {

  String startRoute;
  Map<String, Widget Function(BuildContext)> routes;
  
  final GlobalKey<NavigatorState> _navigationKey;

  MainAplRouter(this._navigationKey);

  void _back() {
    _navigationKey.currentState.pop();
  }

  static T getArgs<T>(BuildContext context) {
    return ModalRoute.of(context).settings.arguments as T;
  }

  @override
  void applyRoute(AplRoute route) {
    if(route is Back) {
      _back();
    } else {
      _navigationKey.currentState.pushNamed(route.name, arguments: route.arguments);
    }
  }
}

class DialogRouter<VM, O> extends AplRouter<DialogResult<O>> {

  final Function(VM, bool, O) resultListener;
  final VM source;

  DialogRouter(AplDialog<VM, O> dialog): resultListener = dialog.resultListener, source = dialog.viewModel;

  @override
  void applyRoute(DialogResult<O> result) {
    resultListener.call(source, result.result, result.output);
  }

}