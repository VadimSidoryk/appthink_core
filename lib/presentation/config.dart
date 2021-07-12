import 'package:applithium_core/blocs/types.dart';
import 'package:applithium_core/services/resources/model.dart';
import 'package:applithium_core/usecases/base.dart';

const _PRESENTATION_CONFIG_TYPE_KEY = "type";

class PresentationConfig {
  final BlocTypes type;
  final Map<String, String> screenStateToUI;
  final ResourceConfig resources;
  final Map<String, UseCase> domain;
  final int ttl;

  PresentationConfig(this.type, this.screenStateToUI, this.resources, this.domain, this.ttl);

  factory PresentationConfig.fromMap(Map<String, dynamic> map) {
      final type =  (map[_PRESENTATION_CONFIG_TYPE_KEY] as String).toBlocType();
      final ui =
  }
}
