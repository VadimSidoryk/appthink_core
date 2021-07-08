import 'package:applithium_core/config/model.dart';

abstract class ConfigProvider {
  Future<AplConfig> getApplicationConfig();
}


