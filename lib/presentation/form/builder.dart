import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/base_repository.dart';
import 'package:applithium_core/presentation/base_builder.dart';
import 'package:applithium_core/presentation/form/repository.dart';
import 'package:applithium_core/usecases/base.dart';

import 'bloc.dart';

class FormPresentationBuilder<T>
    extends AplPresentationBuilder<T, FormRepository<T>> {
  @override
  BlocFactory createBlocFactory(
      FormRepository<T> repository, Map<String, UseCase<T>> domain) {
    return (context) => FormBloc(repository: repository, domain: domain);
  }

  @override
  FormRepository<T> createRepository(Map<String, UseCase<T>> domain, int ttl) {
    final loadUseCase = domain[EVENT_UPDATE_REQUESTED_NAME];
    final sendFormUseCase = domain[EVENT_SEND_FORM_NAME]!;
    return FormRepository(load: loadUseCase, send: sendFormUseCase, ttl: ttl);
  }
}
