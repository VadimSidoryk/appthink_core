import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/presentation/base_builder.dart';
import 'package:applithium_core/presentation/content/repository.dart';
import 'package:applithium_core/usecases/base.dart';

import 'bloc.dart';

class ContentPresenterBuilder<T>
    extends AplPresentationBuilder<T, ContentRepository<T>> {
  @override
  BlocFactory createBlocFactory(
      ContentRepository<T> repository, Map<String, UseCase<T>> domain) {
    return (context) => ContentBloc(repository: repository, domain: domain);
  }

  @override
  ContentRepository<T> createRepository(
      Map<String, UseCase<T>> domain, int ttl) {
    final loadUseCase = domain[EVENT_UPDATE_REQUESTED_NAME]!;
    return ContentRepository(load: loadUseCase, ttl: ttl);
  }
}
