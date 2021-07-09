import 'package:applithium_core/blocs/types.dart';
import 'package:applithium_core/services/resources/model.dart';

class PresentationConfig {
  final BlocTypes type;
  final String ui;
  final ResourceConfig resources;

  PresentationConfig(this.type, this.ui, this.resources);
}
