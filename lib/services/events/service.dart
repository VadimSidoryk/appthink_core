import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/json/condition.dart';
import 'package:applithium_core/json/interpolation.dart';
import 'package:applithium_core/services/analytics/bloc_adapter.dart';
import 'package:applithium_core/services/base.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'action.dart';
import 'event_trigger.dart';

const _countKey = "count";

typedef ActionHandler = Function(SystemAction action, Object? sender);

class EventTriggeredHandlerService  extends AplService {

  final Future<SharedPreferences> _preferencesProvider;
  Map<String, Set<AplEventTrigger>> _triggers = {};
  ActionHandler? _actionsHandler;

  final _interpolation = Interpolation();

  EventTriggeredHandlerService(this._preferencesProvider);

  void setActionHandler(ActionHandler handler) {
    _actionsHandler = handler;
  }

  void handleEvent(AppEvent event) async {
    final key = "${event.name}.$_countKey";
    final count = ((await _preferencesProvider).getInt(key) ?? 0) + 1;
    (await _preferencesProvider).setInt(key, count);

    if (_triggers.containsKey(event.name)) {

      final triggers = _triggers[event.name];
      if(triggers != null) {
        for (final trigger in triggers) {
          bool isHandled;
          try {
            final interpolatedCondition = _interpolation.eval(trigger.condition, event.asArgs()..[_countKey] = count);
            isHandled = Condition.fromString(interpolatedCondition).evaluate() == true;
          } catch (exception) {
            isHandled = false;
          }

          if (isHandled) {
            _actionsHandler?.call(trigger.action, event.params[KEY_SENDER]);
            return;
          }
        }
      }
    }
  }

  @override
  void init(BuildContext context, config) {
    // add triggers from config
  }
}