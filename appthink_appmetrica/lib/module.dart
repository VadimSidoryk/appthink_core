import 'package:appmetrica_sdk/appmetrica_sdk.dart';
import 'package:appthink_core/config/model.dart';
import 'package:appthink_core/module.dart';
import 'package:appthink_core/scopes/store.dart';
import 'package:appthink_core/services/analytics/service.dart';

import 'analyst.dart';

const KEY_APPMETRICA_API_KEY = "app_metrica_api_key";

class AppmetricaModule extends AplModule {
  @override
  Future<bool> injectConfigProvider(Store store) async {
    return false;
  }

  @override
  Future<void> injectDependencies(Store store, AplConfig config) async {
    final apiKey = config.getString(KEY_APPMETRICA_API_KEY);
    final sdk = AppmetricaSdk();
    await sdk.activate(apiKey: apiKey);
    sdk.setStatisticsSending(statisticsSending: true);
    store.get<AnalyticsService>().addAnalyst(AppmetricaAnalyst(sdk));
  }
}