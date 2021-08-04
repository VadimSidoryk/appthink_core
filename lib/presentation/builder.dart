import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/base.dart';
import 'package:applithium_core/router/route_details.dart';
import 'package:applithium_core/scopes/scope.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:flutter/cupertino.dart';

WidgetBuilderWithRouteResult presentationScope<M>(
    AplWidget<M, dynamic> Function(BuildContext) widgetProvider,
    {int ttl = 1000}) {
  return (context, result) {
    final path = result.uri.toString();
    final presentationStore = Store()
      ..add((provider) => AplRepository<M>(ttl), key: path);
    return Scope(
        parentContext: context,
        builder: widgetProvider,
        store: presentationStore);
  };
}
