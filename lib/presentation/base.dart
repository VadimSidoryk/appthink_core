import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/json/interpolation.dart';
import 'package:applithium_core/presentation/base_builder.dart';
import 'package:applithium_core/presentation/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AplPresentation extends StatefulWidget {
  final String path;
  final PresentationConfig config;
  final BlocFactory currentBlocFactory;

  AplPresentation(
      {Key? key,
      required this.path,
      required this.config,
      required this.currentBlocFactory});

  @override
  State<StatefulWidget> createState() {
    return _AplPresentationState(
        blocFactory: currentBlocFactory, stateToUI: config.stateToUI);
  }
}

class _AplPresentationState extends State<AplPresentation> {
  final BlocFactory blocFactory;
  final Map<String, String> stateToUI;

  final _interpolation = Interpolation();

  late final BaseBloc bloc;

  _AplPresentationState({required this.blocFactory, required this.stateToUI});

  @override
  Widget build(BuildContext context) {
    bloc = blocFactory(context, _buildPresenters(context));
    return BlocBuilder<BaseBloc, BaseState>(
        bloc: bloc,
        builder: (context, state) {
          final uiBuilder = context.get<AplLayoutBuilder>();
          final uiConfig =
              stateToUI[state.tag] ?? stateToUI[STATE_BASE_ERROR_TAG]!;
          final interpolatedUIConfig =
              _interpolation.eval(uiConfig, state.asArgs());
          return uiBuilder.buildLayout(interpolatedUIConfig, _processEvent);
        });
  }

  void _processEvent({required String name, Map<String, Object>? params}) {
    bloc.add(AplEvent(name: name, params: params ?? {}));
  }

  Presenters _buildPresenters(BuildContext context) {
    return Presenters(dialogPresenter: _showDialog, toastPresenter: _showToast);
  }

  Future<dynamic> _showDialog(String dialogPath) {
    return showDialog(
        context: context,
        builder: (context) {
          final config = context.get<ApplicationConfig>().getFor(dialogPath);
          final typeToBlocFactoryProvider =
              context.get<Map<String, AplPresentationBuilder>>();
          final presentationBuilder = typeToBlocFactoryProvider[config.type]!;
          return AplPresentation(
              path: dialogPath,
              config: config,
              currentBlocFactory:
                  presentationBuilder.buildPresentation(dialogPath, config));
        });
  }

  Future<dynamic> _showToast(String toastPath) {
    return Fluttertoast.showToast(
        msg: "toastPath",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
