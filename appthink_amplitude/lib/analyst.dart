import 'package:amplitude_flutter/amplitude.dart';
import 'package:applithium_core/services/analytics/analyst.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/widgets.dart';

const _EVENT_SCREEN_VIEW = "screen_view";
const _PARAM_SCREEN_NAME = "screen_name";

typedef ScreenNameExtractor = String? Function(RouteSettings settings);

String? defaultNameExtractor(RouteSettings settings) => settings.name;

class AmplitudeAnalyst extends Analyst {
  final Amplitude _sdk;
  final ScreenNameExtractor nameExtractor;

  AmplitudeAnalyst(this._sdk, {this.nameExtractor = defaultNameExtractor});

  @override
  List<NavigatorObserver> get navigatorObservers =>
      [_AmplitudeNavigatorObserver(_sdk, nameExtractor)];

  @override
  void setUserProperty(String name, Object? value) {
    _sdk.setUserProperties(<String, dynamic>{name: value});
  }

  @override
  void sendEvent(String name, Map<String, Object?>? params) {
    _sdk.logEvent(name, eventProperties: params ?? <String, dynamic>{});
  }
}

class _AmplitudeNavigatorObserver extends RouteObserver<PageRoute<dynamic>> {
  final Amplitude _sdk;
  final ScreenNameExtractor _nameExtractor;

  _AmplitudeNavigatorObserver(this._sdk, this._nameExtractor);

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
    if (screenName != null) {
      log("sending screen view");
      _sdk.logEvent(_EVENT_SCREEN_VIEW,
          eventProperties: {_PARAM_SCREEN_NAME: screenName});
    } else {
      logError("nameExtractor returns null");
    }
  }
}
