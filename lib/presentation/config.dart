import 'package:applithium_core/usecases/base.dart';

class PresentationConfig {
  final String type;
  final Map<String, dynamic> stateToUI;
  final Map<String, UseCase> domain;
  final int repositoryTtl;

  PresentationConfig(this.type, this.stateToUI, this.domain, this.repositoryTtl);

}
