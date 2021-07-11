import 'package:applithium_core/blocs/types.dart';
import 'package:applithium_core/services/resources/model.dart';
import 'package:applithium_core/usecases/base.dart';

class PresentationConfig {
  final BlocTypes type;
  final String ui;
  final ResourceConfig resources;
  final Map<String, UseCase> domain;
  final int ttl;

  PresentationConfig(this.type, this.ui, this.resources, this.domain, this.ttl);
}
