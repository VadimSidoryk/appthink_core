import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/config/provider.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:applithium_core/logs/extension.dart';

const FIREBASE_CONFIG_RESOURCES_KEY = "utils";
const FIREBASE_CONFIG_EVENTS_KEY = "event_handlers";
const FIREBASE_CONFIG_PRESENTATION_KEY = "presentation";

class FirebaseConfigProvider extends ConfigProvider {
  final int fetchTimeoutSec;
  final Map<String, dynamic> defaults;

  FirebaseConfigProvider(
      {required this.fetchTimeoutSec, this.defaults = const {}});

  @override
  Future<AplConfig> getApplicationConfig() async {
    final methodName = "getApplicationConfig";
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: fetchTimeoutSec),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    log("setDefaults $defaults");
    await remoteConfig.setDefaults(defaults);
    try {
      log("fetch and activate");
      await remoteConfig.fetchAndActivate();
      RemoteConfigValue(null, ValueSource.valueStatic);
    } catch (e, stacktrace) {
      logError(methodName, e, stacktrace);
    }
    return FirebaseAplConfigAdapter(remoteConfig);
  }
}

class FirebaseAplConfigAdapter extends AplConfig {
  final RemoteConfig configImpl;

  FirebaseAplConfigAdapter(this.configImpl);

  @override
  bool getBool(String key) {
    final methodName = "getBool";
    try {
      return configImpl.getBool(key);
    } catch (e, stacktrace) {
      logError(methodName, e, stacktrace);
      return false;
    }
  }

  @override
  double getDouble(String key) {
    final methodName = "getDouble";
    try {
      return configImpl.getDouble(key);
    } catch (e, stacktrace) {
      logError(methodName, e, stacktrace);
      return 0;
    }
  }

  @override
  int getInt(String key) {
    final methodName = "getInt";
    try {
      return configImpl.getInt(key);
    } catch (e, stacktrace) {
      logError(methodName, e, stacktrace);
      return 0;
    }
  }

  @override
  String getString(String key) {
    final methodName = "getString";
    try {
      return configImpl.getString(key);
    } catch (e, stacktrace) {
      logError(methodName, e, stacktrace);
      return "";
    }
  }
}
