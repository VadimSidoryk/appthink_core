import 'package:applithium_core/config/model.dart';

abstract class AplService {
  Future<void> init(AplConfig config);
}