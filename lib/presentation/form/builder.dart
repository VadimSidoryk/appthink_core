import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/presentation/builder.dart';
import 'package:applithium_core/presentation/form/repository.dart';
import 'package:applithium_core/usecases/base.dart';

import 'bloc.dart';

const PRESENTATION_FORM_TYPE = "form";

class FormPresentationBuilder<T>
    extends AplPresentationBuilder<T, FormRepository<T>> {
  @override
  BlocFactory createBlocFactory(
      FormRepository<T> repository, Map<String, UseCase<T>> domain) {
    return (context, presenters) => FormBloc(
        repository: repository, domain: domain, presenters: presenters);
  }

  @override
  FormRepository<T> createRepository(Map<String, UseCase<T>> domain, int ttl) {
    final loadUseCase = domain[EVENT_UPDATE_REQUESTED_NAME];
    final sendFormUseCase = domain[EVENT_SEND_FORM_NAME]!;
    return FormRepository(load: loadUseCase, send: sendFormUseCase, ttl: ttl);
  }
}
