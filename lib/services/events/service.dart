import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';

class AppEventsService  {

  static Future<AppEventsService> get onInitialized => _initializedSubject.future;
  static final _initializedSubject = Completer<AppEventsService>();

  static AppEventsService _instance;

  static AppEventsService get instance {
    if (_instance == null) {
      throw "Service is not initialized";
    } else {
      return _instance;
    }
  }

  static void init(GlobalKey<NavigatorState> navigatorKey, SharedPreferences preferences) {
    _instance = AppEventsService._(navigatorKey, preferences);
    _initializedSubject.complete(_instance);
  }

  final SharedPreferences _preferences;
  final GlobalKey<NavigatorState> _navigatorKey;
  final Map<String, List<Future<bool> Function(BuildContext, int)>>
  _eventCheckers = {};

  AppEventsService._(this._navigatorKey, this._preferences);

  void registerEventTrigger(EventTriggerModel model,
      Future<bool> Function(BuildContext) onTriggered) {
    if (!_eventCheckers.containsKey(model.eventName)) {
      _eventCheckers[model.eventName] = [];
    }

    final list = _eventCheckers[model.eventName];
    Future<bool> Function(BuildContext, int) trigger;
    switch (model.operator) {
      case Operator.equals:
        trigger = _createEqualsTrigger(model.count, onTriggered);
        break;
      case Operator.greater:
        trigger = _createGreaterTrigger(model.count, onTriggered);
        break;
      case Operator.mod:
        trigger = _createModTrigger(model.count, onTriggered);
        break;
    }

    list.add(trigger);
  }

  void checkEvent(String name) async {
    final key = "$name.count";
    final count = (_preferences.getInt(key) ?? 0) + 1;
    _preferences.setInt(key, count);

    if (_eventCheckers.containsKey(name)) {
      final context = _navigatorKey.currentState.overlay.context;

      for (final checker in _eventCheckers[name]) {
        bool isHandled;
        try {
          isHandled = await checker(context, count);
        } catch (exception) {
          isHandled = false;
        }

        if (isHandled) {
          return;
        }
      }
    }
  }

  static Future<bool> Function(BuildContext, int) _createModTrigger(
      int modBy, Future<bool> Function(BuildContext) onTriggered) =>
          (context, eventCount) async {
        if (eventCount % modBy == 0) {
          return await onTriggered(context);
        } else {
          return false;
        }
      };

  static Future<bool> Function(BuildContext, int) _createEqualsTrigger(
      int equals, Future<bool> Function(BuildContext) onTriggered) =>
          (context, eventCount) async {
        if (eventCount == equals) {
          return await onTriggered(context);
        } else {
          return false;
        }
      };

  static Future<bool> Function(BuildContext, int) _createGreaterTrigger(
      int greaterThen, Future<bool> Function(BuildContext) onTriggered) =>
          (context, eventCount) async {
        if (eventCount > greaterThen) {
          return await onTriggered(context);
        } else {
          return false;
        }
      };
}