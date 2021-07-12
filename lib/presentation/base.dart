import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/blocs/form_bloc.dart';
import 'package:applithium_core/blocs/listing_bloc.dart';
import 'package:applithium_core/blocs/types.dart';
import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/json/interpolation.dart';
import 'package:applithium_core/presentation/builder.dart';
import 'package:applithium_core/presentation/config.dart';
import 'package:applithium_core/repositories/value_repository.dart';
import 'package:applithium_core/repositories/form_repository.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:applithium_core/services/resources/model.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef BlocFactory = BaseBloc Function(BuildContext);

class AplPresentation extends StatefulWidget {

  final String path;
  final PresentationConfig config;

  const AplPresentation({Key? key, required this.path, required this.config})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AplPresentationState(
        blocFactory: _getBlocFactory(config.type),
        stateToUIConfig: _buildUiConfigWithResources(config.resources, config.screenStateToUI)
    );
  }

  BlocFactory _getBlocFactory(BlocTypes type) {
    switch (type) {
      case BlocTypes.CONTENT:
        final loadUseCase = config.domain[EVENT_UPDATE_REQUESTED_NAME]!;
        //TODO: get repository from DI lib
        final repository = ContentRepository(
            load: loadUseCase,
            ttl: config.ttl);
        return (context) =>
            ContentBloc(
                presenters: _buildPresenters(context),
                repository: repository,
                domain: config.domain
            );
      case BlocTypes.FORM:
        final loadUseCase = config.domain[EVENT_UPDATE_REQUESTED_NAME];
        final sendFormUseCase = config.domain[EVENT_SEND_FORM_NAME]!;
        //TODO: get repository from DI lib
        final repository = FormRepository(
            load: loadUseCase,
            send: sendFormUseCase,
            ttl: config.ttl
        );
        return (context) =>
            FormBloc(
                presenters: _buildPresenters(context),
                repository: repository,
                domain: config.domain
            );
      case BlocTypes.LISTING:
      //TODO: get repository from DI lib
        final repository = ListingRepository(
            config.domain[EVENT_UPDATE_REQUESTED_NAME] as UseCase<List>,
            ttl: config.ttl
        );
        return (context) =>
            ListingBloc(
                repository: repository,
                presenters: _buildPresenters(context),
                domain: config.domain as Map<String, UseCase<List<dynamic>>>
            );
    }
  }

  String _buildUiConfigWithResources(ResourceConfig resources, String ui) {
    //TODO: replace strings in ui with ones from resources
    return ui;
  }

  Presenters _buildPresenters(BuildContext context) {
    return Presenters(
        dialogPresenter: (dialogPath) => _showDialog(context, dialogPath),
        toastPresenter: (toastPath) => _showToast(context, toastPath)
    );
  }

  Future<dynamic> _showDialog(BuildContext context, String dialogPath) {
    return showDialog(context: context,
        builder: (context) =>
            AplPresentation(path: dialogPath,
                config: context.get<ApplicationConfig>().getFor(dialogPath)));
  }

  Future<dynamic> _showToast(BuildContext context, String toastPath) {
    return Fluttertoast.showToast(
        msg: "toastPath",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

class _AplPresentationState extends State<AplPresentation> {

  final BlocFactory blocFactory;
  final Map<String, String> stateToUIConfig;

  final _interpolation = Interpolation();

  late final BaseBloc bloc;

  _AplPresentationState({required this.blocFactory, required this.stateToUIConfig});

  @override
  Widget build(BuildContext context) {
    bloc = blocFactory(context);
    return BlocBuilder<BaseBloc, BaseState>(
      bloc: bloc,
      builder: (context, state) {
        final uiBuilder = context.get<UIBuilder>();
        final uiConfig = stateToUIConfig[state.tag] ?? stateToUIConfig[STATE_BASE_ERROR_TAG]!;
        final interpolatedUIConfig = _interpolation.eval(uiConfig, state);
        return uiBuilder.buildUI(interpolatedUIConfig, _processEvent);
      }
    );
  }

  void _processEvent({required String name, Map<String, Object>? params}) {
    bloc.add(AplEvent(name: name, params: params ?? {}));
  }
}