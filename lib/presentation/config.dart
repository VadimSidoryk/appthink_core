
import '../domain/base_bloc.dart';

class PresentationConfig<T> {
  final String type;
  final Map<String, T> stateToUI;
  final DomainGraph domain;
  final int repositoryTtl;

  PresentationConfig(this.type, this.stateToUI, this.domain, this.repositoryTtl);

}
