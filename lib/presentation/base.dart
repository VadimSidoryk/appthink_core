import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/blocs/form_bloc.dart';
import 'package:applithium_core/blocs/listing_bloc.dart';
import 'package:applithium_core/blocs/types.dart';
import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/presentation/builder.dart';
import 'package:applithium_core/presentation/config.dart';
import 'package:applithium_core/repositories/value_repository.dart';
import 'package:applithium_core/repositories/form_repository.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:applithium_core/services/resources/model.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/scopes/extensions.dart';

class AplPresentation extends StatefulWidget {

  final String path;
  final PresentationConfig config;

  const AplPresentation({Key? key, required this.path, required this.config}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AplPresentationState(
      bloc: _buildBloc(config.type),
      uiConfig: _buildUiConfigWithResources(config.resources, config.ui)
    );
  }

  BaseBloc _buildBloc(BlocTypes type) {
    switch(type) {
      case BlocTypes.CONTENT:
        final loadUseCase = config.domain[EVENT_UPDATE_REQUESTED_NAME]!;
        final repository = ContentRepository(
            load: loadUseCase,
            ttl: config.ttl);
        return ContentBloc(
          presenters: _buildPresenters(),
          repository: repository,
          domain: config.domain
        );
      case BlocTypes.FORM:
        final loadUseCase = config.domain[EVENT_UPDATE_REQUESTED_NAME];
        final sendFormUseCase = config.domain[EVENT_SEND_FORM_NAME]!;
        final repository = FormRepository(
          load: loadUseCase,
          send: sendFormUseCase,
          ttl: config.ttl
        );
        return FormBloc(
            presenters: _buildPresenters(),
            repository: repository,
            domain: config.domain
        );
      case BlocTypes.LISTING:
        final repository = ListingRepository();
        return ListingBloc(repository, _buildPresenters());
    }
  }

  String _buildUiConfigWithResources(ResourceConfig resources, String ui) {
    return ui
  }

  Presenters _buildPresenters() {
    return Presenters();
  }
}

class _AplPresentationState extends State<AplPresentation> {

  final BaseBloc bloc;
  final String uiConfig;

  _AplPresentationState({required this.bloc, required this.uiConfig});

  @override
  Widget build(BuildContext context) {
    return context.get<PresentationBuilder>().buildUI(uiConfig, _processEvent);
  }

  void _processEvent({required String name, Map<String, Object>? params}) {
    bloc.add(AplEvent(name: name, params: params ?? {}));
  }
}