import 'package:applithium_core/usecases/base.dart';

class PresentationConfig<T> {
  final String type;
  final Map<String, T> stateToUI;
  final Map<String, UseCase> domain;
  final int repositoryTtl;

  PresentationConfig(this.type, this.stateToUI, this.domain, this.repositoryTtl);

}
