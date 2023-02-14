import 'package:appthink_core/scopes/scope.dart';
import 'package:appthink_core/scopes/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScopeUtils {
  ScopeUtils._();

  static Future<T?> showDialogInScope<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    final initialStore = Scope.of(context)?.store ?? Store();
    return showDialog(
      context: context,
      builder: (dialogContext) => Scope(
          parentContext: dialogContext,
          builder: builder,
          store: Store()..extend(initialStore)),
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings
    );
  }
}
