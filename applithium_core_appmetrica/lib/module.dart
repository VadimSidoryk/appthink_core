import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/module/base.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:appmetrica_sdk/appmetrica_sdk.dart';
import 'package:applithium_core/utils/extentions.dart';

import 'analyst.dart';

const _KEY_APPMETRICA_API_KEY = "app_metrica_api_key";

class AppmetricaModule extends AplModule {
  @override
  Future<bool> injectConfigProvider(Store store) async {
    return false;
  }

  @override
  Future<void> injectDependencies(Store store, AplConfig config) async {
    config.getString(_KEY_APPMETRICA_API_KEY).value?.let((apiKey) async {
      final sdk = AppmetricaSdk();
      await sdk.activate(apiKey: apiKey);
      sdk.setStatisticsSending(statisticsSending: true);
      store.getOrNull<AnalyticsService>()?.let((val) => val.addAnalyst(AppmetricaAnalyst(sdk)));
    });

  }
}