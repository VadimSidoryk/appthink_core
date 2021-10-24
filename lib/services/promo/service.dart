import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/events/base_event.dart';
import 'package:applithium_core/events/event_bus.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/promo/analyst_adapter.dart';
import 'package:applithium_core/services/promo/config.dart';
import 'package:applithium_core/services/service_base.dart';
import 'package:applithium_core/utils/json/condition.dart';
import 'package:applithium_core/utils/json/interpolation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'action.dart';

const _countKey = "count";

typedef ActionHandler = Function(PromoAction action, Object? sender);

class PromoService extends AplService {

  late Future<SharedPreferences> _preferencesProvider;
  ActionHandler? _actionsHandler;
  late PromoConfig _promoConfig;
  final _interpolation = Interpolation();

  PromoService();

  @override
  Future<void> init(AplConfig appConfig) async {
    _promoConfig = appConfig.promoConfig;
  }

  void setActionHandler(ActionHandler handler) {
    _actionsHandler = handler;
  }

  void handleEvent(AplEvent event) async {
    final key = "${event.name}.$_countKey";
    final count = ((await _preferencesProvider).getInt(key) ?? 0) + 1;
    (await _preferencesProvider).setInt(key, count);

    if (_promoConfig.triggers.containsKey(event.name)) {

      final triggers = _promoConfig.triggers[event.name];
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
            _actionsHandler?.call(trigger.action, event.params["sender"]);
            return;
          }
        }
      }
    }
  }

  @override
  void addToStore(Store store) {
    store.add((provider) {
      this._preferencesProvider = provider.get();
      provider.get<EventBus>().addListener(PromoEventsAdapter(this));
      return this;
    });
  }
}

extension _PromoAplConfig on AplConfig {

  static const _KEY_PROMO_CONFIG = "promo";

  PromoConfig get promoConfig {
    return PromoConfig({});
  }
}