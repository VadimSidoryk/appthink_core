import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/config/provider.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/services/localization/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

const FIREBASE_CONFIG_RESOURCES_KEY = "resources";
const FIREBASE_CONFIG_EVENTS_KEY = "event_handlers";
const FIREBASE_CONFIG_PRESENTATION_KEY = "presentation";

class FirebaseConfigProvider extends ConfigProvider {

  final int fetchTimeoutSec;
  final Map<String, dynamic> defaults;

  FirebaseConfigProvider({required this.fetchTimeoutSec, this.defaults = const {}});

  @override
  Future<AplConfig> getApplicationConfig() async {
    logMethod("getApplicationConfig");
    await Firebase.initializeApp();
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: fetchTimeoutSec),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    // await remoteConfig.setDefaults(defaults);
    await remoteConfig.fetchAndActivate();
    RemoteConfigValue(null, ValueSource.valueStatic);
    final testValue = remoteConfig.getString("test_value");
    log("remoteConfig = $testValue");

    return AplConfig(
      messagingApiKey: "",
      localizations: LocalizationConfig({})
    );

  }

}