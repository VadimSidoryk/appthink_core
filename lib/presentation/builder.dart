
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/config.dart';
import 'package:applithium_core/presentation/base_repository.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:flutter/widgets.dart';

typedef EventHandler = Function({required String name, Map<String, Object>? params});

typedef BlocFactory = BaseBloc Function(BuildContext, Presenters);

abstract class AplPresentationBuilder<D, R extends BaseRepository<D>> {

  BlocFactory buildPresentation(BuildContext context, PresentationConfig config) {
    final domain = config.domain as Map<String, UseCase<D>>;
    final repository = createRepository(domain, config.repositoryTtl);
    return createBlocFactory(repository, domain);
  }

  @protected
  R createRepository(Map<String, UseCase<D>> domain, int ttl);

  @protected
  BlocFactory createBlocFactory(R repository, Map<String, UseCase<D>> domain);
}

abstract class AplLayoutBuilder<T> {
  Widget buildLayout(T uiConfig, BaseState state, EventHandler handler);
}
