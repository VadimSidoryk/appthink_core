
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/config.dart';
import 'package:applithium_core/presentation/base_repository.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:flutter/widgets.dart';

typedef EventHandler = Function({required String name, Map<String, Object>? params});

typedef BlocFactory = BaseBloc Function(BuildContext, Presenters);

abstract class AplPresentationBuilder<D, R extends BaseRepository<D>> {
  BlocFactory buildPresentation(BuildContext context, String path, PresentationConfig config) {
    final domain = config.domain as Map<String, UseCase<D>>;
    final repository = createRepository(domain, config.repositoryTtl);
    return createBlocFactory(repository, domain);
  }

  R createRepository(Map<String, UseCase<D>> domain, int ttl);

  BlocFactory createBlocFactory(R repository, Map<String, UseCase<D>> domain);
}

abstract class AplLayoutBuilder {
  Widget buildLayout(String uiConfig, EventHandler handler);
}
