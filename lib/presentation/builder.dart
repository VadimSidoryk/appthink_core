import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/base.dart';
import 'package:applithium_core/router/route_details.dart';
import 'package:applithium_core/scopes/scope.dart';
import 'package:applithium_core/scopes/store.dart';

WidgetBuilderWithRouteResult presentationScope<M>(AplWidget<M, dynamic> Function() widgetProvider, { int ttl = 1000}) {
  return (context, result) {
    final presentationStore = Store()..add((provider) => AplRepository<M>(ttl), key: result.uri.toString());
    return Scope(
      child: widgetProvider.call(),
      store: presentationStore
    );
  };
}