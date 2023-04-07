import 'package:amplitude_flutter/amplitude.dart';
import 'package:appthink_core/config/model.dart';
import 'package:appthink_core/logs/extension.dart';
import 'package:appthink_core/module.dart';
import 'package:appthink_core/scopes/store.dart';
import 'package:appthink_core/services/analytics/service.dart';
import 'package:appthink_core/utils/extension.dart';

import 'analyst.dart';

class AmplitudeModule extends AplModule {

  final String sdkKey;

  AmplitudeModule(this.sdkKey);

  @override
  Future<bool> injectConfigProvider(Store store) async {
    return false;
  }

  @override
  Future<void> injectDependencies(Store store, AplConfig config) async {
    final Amplitude sdk = Amplitude.getInstance();
    await sdk.init(sdkKey);
    store.get<AnalyticsService>().addAnalyst(AmplitudeAnalyst(sdk));
  }
}

