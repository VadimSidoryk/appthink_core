import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/config/provider.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/utils/either.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

const FIREBASE_CONFIG_RESOURCES_KEY = "resources";
const FIREBASE_CONFIG_EVENTS_KEY = "event_handlers";
const FIREBASE_CONFIG_PRESENTATION_KEY = "presentation";

class FirebaseConfigProvider extends ConfigProvider {
  final int fetchTimeoutSec;
  final Map<String, dynamic> defaults;

  FirebaseConfigProvider(
      {required this.fetchTimeoutSec, this.defaults = const {}});

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
  final RemoteConfig _impl;

  FirebaseAplConfigAdapter(this._impl);

  @override
  Either<bool> getBool(String key) {
    try {
      return Either.withValue(_impl.getBool(key));
    } catch (e, stacktrace) {
      logError("getBool", ex: e, stacktrace: stacktrace);
      return Either.withError(e);
    }
  }

  @override
  Either<double> getDouble(String key) {
    try {
      return Either.withValue(_impl.getDouble(key));
    } catch (e, stacktrace) {
      logError("getDouble", ex: e, stacktrace: stacktrace);
      return Either.withError(e);
    }
  }

  @override
  Either<int> getInt(String key) {
    try {
      return Either.withValue(_impl.getInt(key));
    } catch (e, stacktrace) {
      logError("getInt", ex: e, stacktrace: stacktrace);
      return Either.withError(e);
    }
  }

  @override
  Either<String> getString(String key) {
    try {
      return Either.withValue(_impl.getString(key));
    } catch (e, stacktrace) {
      logError("getString", ex: e, stacktrace: stacktrace);
      return Either.withError(e);
    }
  }
}
