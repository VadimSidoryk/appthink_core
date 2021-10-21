import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:appmetrica_sdk/appmetrica_sdk.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/logs/extension.dart';


const _EVENT_SCREEN_VIEW = "screen_view";
const _PARAM_SCREEN_NAME = "screen_name";

typedef ScreenNameExtractor = String? Function(RouteSettings settings);

String? defaultNameExtractor(RouteSettings settings) => settings.name;

class AppmetricaAnalyst extends Analyst {

  final AppmetricaSdk _sdk;
  final ScreenNameExtractor nameExtractor;

  AppmetricaAnalyst(this._sdk, { this.nameExtractor = defaultNameExtractor});

  @override
  List<NavigatorObserver> get navigatorObservers => [_AppmetricaNavigatorObserver(_sdk, nameExtractor)];

  @override
  void setUserProperty(String name, Object? value) {
    if(value is int) {
      _sdk.reportUserProfileCustomNumber(key: name, value: value.toDouble());
    } else if(value is double) {
      _sdk.reportUserProfileCustomNumber(key: name, value: value);
    } else if(value is bool) {
      _sdk.reportUserProfileCustomBoolean(key: name, value: value);
    } else {
      if(value != null) {
        _sdk.reportUserProfileCustomString(key: name, value: value.toString());
      } else {
        _sdk.reportUserProfileCustomString(key: name, value: "null");
      }
    }
  }

  @override
  void onNewEvent(AplEvent event) {
    _sdk.reportEvent(name: event.name, attributes: event.params);
  }
}

class _AppmetricaNavigatorObserver extends RouteObserver<PageRoute<dynamic>> {

  final AppmetricaSdk _sdk;
  final ScreenNameExtractor _nameExtractor;

  _AppmetricaNavigatorObserver(this._sdk, this._nameExtractor);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }

  void _sendScreenView(PageRoute<dynamic> route) {
    final String? screenName = _nameExtractor(route.settings);
    if(screenName != null) {
      log("sending screen view");
      _sdk.reportEvent(name: _EVENT_SCREEN_VIEW, attributes: {
        _PARAM_SCREEN_NAME : screenName
      });
    } else {
      logError("nameExtractor returns null");
    }
  }
}