import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/config/provider.dart';
import 'package:applithium_core/logs/extension.dart';
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
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: fetchTimeoutSec),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    // await remoteConfig.setDefaults(defaults);
    await remoteConfig.fetchAndActivate();
    RemoteConfigValue(null, ValueSource.valueStatic);
    return FirebaseAplConfigAdapter(remoteConfig);
  }
}

class FirebaseAplConfigAdapter extends AplConfig {

  final RemoteConfig configImpl;

  FirebaseAplConfigAdapter(this.configImpl);

  @override
  bool getBool(String key) {
    return configImpl.getBool(key);
  }

  @override
  double getDouble(String key) {
    return configImpl.getDouble(key);
  }

  @override
  int getInt(String key) {
    return configImpl.getInt(key);
  }

  @override
  String getString(String key) {
    return configImpl.getString(key);
  }

}