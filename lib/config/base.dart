import 'package:applithium_core/config/model.dart';

abstract class ConfigProvider<C extends AplConfig> {
  Future<C> receiveConfig();
}