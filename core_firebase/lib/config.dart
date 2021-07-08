import 'package:applithium_core/config/base.dart';
import 'package:applithium_core/config/model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

const KEY_RESOURCES = "resources";
const KEY_EVENT_HANDLERS = "event_handlers";


class FirebaseConfigProvider extends ConfigProvider {

  final int fetchTimeoutSec;
  final Map<String, dynamic> defaults;

  FirebaseConfigProvider({required this.fetchTimeoutSec, this.defaults = const {}});

  @override
  Future<AplConfig> getApplicationConfig() async {
    await Firebase.initializeApp();
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: fetchTimeoutSec),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.setDefaults(defaults);
    RemoteConfigValue(null, ValueSource.valueStatic);

    return AplConfig(
      resources: remoteConfig.getValue(KEY_RESOURCES) as Map<String, Map<String, String>>,
      eventHandlers: remoteConfig.getValue(KEY_EVENT_HANDLERS) as Map<String, Map<String, dynamic>>
    );
  }

}