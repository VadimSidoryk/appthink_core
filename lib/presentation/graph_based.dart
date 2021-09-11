
import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/domain/repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base.dart';

abstract class GraphBasedWidget<M, S extends BaseState<M>> extends BaseWidget<M, S> {

  @protected
  AplRepository<M> repository = AplRepository<M>(-1);

  GraphBasedWidget(WidgetForStateFactory<M, S> widgetForStateFactory) : super(widgetForStateFactory);

  @protected
  S getInitialState();

  @protected
  DomainGraph<M, S> get domainGraph;

  @protected
  Bloc<WidgetEvents, S> createBloc(BuildContext context) {
    return AplBloc(
        initialState: getInitialState(),
        repository: repository,
        customGraph: domainGraph
    );
  }
}