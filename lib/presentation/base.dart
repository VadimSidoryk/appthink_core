import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/blocs/listing_bloc.dart';
import 'package:applithium_core/blocs/types.dart';
import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/presentation/builder.dart';
import 'package:applithium_core/presentation/config.dart';
import 'package:applithium_core/services/resources/model.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/scopes/extensions.dart';

class AplPresentation extends StatefulWidget {

  final PresentationConfig config;

  const AplPresentation({Key? key, required this.config}) : super(key: key);

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
        return ContentBloc();
      case BlocTypes.FORM:
        return ContentBloc();
      case BlocTypes.LISTING:
        return ListingBloc();
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
    return context.get<UIBuilder>().buildUI(uiConfig, _processEvent);
  }

  void _processEvent({required String name, Map<String, Object>? params}) {
    bloc.add(AplEvent(name: name, params: params ?? {}));
  }
}