import 'dart:async';

import 'package:applithium_core/json/condition.dart';
import 'package:applithium_core/json/interpolation.dart';
import 'package:applithium_core/services/base.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';

const _countKey = "count";

typedef ActionHandler = Function(String);

class AppEventsService  extends AplService {

  final SharedPreferences _preferences;
  final Map<String, Set<EventTriggerModel>> _triggers;
  final ActionHandler _routesHandler;

  final _interpolation = Interpolation();

  AppEventsService._(this._preferences, this._triggers, this._routesHandler,);

  void checkEvent({required String name, Map<String, Object>? params}) async {
    final key = "$name.$_countKey";
    final count = (_preferences.getInt(key) ?? 0) + 1;
    _preferences.setInt(key, count);

    if (_triggers.containsKey(name)) {

      final triggers = _triggers[name];
      if(triggers != null) {
        for (final trigger in triggers) {
          bool isHandled;
          try {
            final interpolatedCondition = _interpolation.eval(trigger.condition, (params ?? {})..[_countKey] = count);
            isHandled = Condition.fromString(interpolatedCondition).evaluate() == true;
          } catch (exception) {
            isHandled = false;
          }

          if (isHandled) {
            _routesHandler.call(trigger.action);
            return;
          }
        }
      }
    }
  }

  @override
  void init(BuildContext context, config) {
    // TODO: implement init
  }
}