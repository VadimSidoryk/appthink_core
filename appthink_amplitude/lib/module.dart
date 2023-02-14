import 'package:amplitude_flutter/amplitude.dart';
import 'package:appthink_core/config/model.dart';
import 'package:appthink_core/logs/extension.dart';
import 'package:appthink_core/module.dart';
import 'package:appthink_core/scopes/store.dart';
import 'package:appthink_core/services/analytics/service.dart';
import 'package:appthink_core/utils/extension.dart';
import 'package:async/async.dart';

import 'analyst.dart';

class AmplitudeModule extends AplModule {

  @override
  Future<bool> injectConfigProvider(Store store) async {
    return false;
  }

  @override
  Future<void> injectDependencies(Store store, AplConfig config) async {
    final apiKeyResult = await config.apiKey;
    if(apiKeyResult.isError) {
      logError(apiKeyResult.asError?.error.toString() ?? "Can't get apiKey");
    }
    final projectIdResult = await config.projId;
    if(projectIdResult.isError) {
      logError(projectIdResult.asError?.error.toString() ?? "Can't get projId");
    }
    final Amplitude sdk = Amplitude.getInstance(instanceName: projectIdResult.asValue!.value);
    await sdk.init(apiKeyResult.asValue!.value);
    store.get<AnalyticsService>().addAnalyst(AmplitudeAnalyst(sdk));
  }
}

extension AmplitudeModuleKeys on AplConfig {
  static const KEY_AMPLITUDE_API_KEY = "amplitude_api_key";
  static const KEY_AMPLITUDE_PROJECT_ID = "amplitude_proj_id";

  Future<Result<String>> get apiKey => safeCall(() => this.getString(KEY_AMPLITUDE_API_KEY));

  Future<Result<String>> get projId => safeCall(() => this.getString(KEY_AMPLITUDE_PROJECT_ID));


}