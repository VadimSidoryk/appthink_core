import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/events/navigator.dart';
import 'package:applithium_core/presentation/screen.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AplParentScreenState<W extends StatefulWidget> extends AplScreenState<W> {

  Key? get appKey => null;

  String get initialRoute;

  Map<String, WidgetBuilder> get routes;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(key: appKey,
      initialRoute: initialRoute,
      routes: routes,
      navigatorObservers: [NavigatorEventsObserver(context.get<EventBus>())],
    );
  }
}