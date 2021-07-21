import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/presentation/builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AplPresentation<T> extends StatefulWidget {
  final Map<String, T> stateToUI;
  final BlocFactory currentBlocFactory;
  final AplLayoutBuilder<T> layoutBuilder;

  AplPresentation(
      {Key? key,
      required this.stateToUI,
      required this.currentBlocFactory,
      required this.layoutBuilder});

  @override
  State<StatefulWidget> createState() {
    return _AplPresentationState(
        blocFactory: currentBlocFactory,
        stateToUI: stateToUI,
        layoutBuilder: layoutBuilder);
  }
}

class _AplPresentationState<T> extends State<AplPresentation> {
  final BlocFactory blocFactory;
  final Map<String, T> stateToUI;
  final AplLayoutBuilder<T> layoutBuilder;

  late final BaseBloc bloc;

  _AplPresentationState(
      {required this.blocFactory,
      required this.stateToUI,
      required this.layoutBuilder});

  @override
  Widget build(BuildContext context) {
    bloc = blocFactory(context, _buildPresenters(context));
    bloc..add(AplEvent.screenCreated());
    return BlocBuilder<BaseBloc, BaseState>(
        bloc: bloc,
        builder: (context, state) {
          final uiConfig =
              stateToUI[state.tag] ?? stateToUI[STATE_BASE_ERROR_TAG]!;
          return layoutBuilder.buildLayout(
              context, uiConfig, state, _processEvent);
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
              stateToUI: config.stateToUI,
              layoutBuilder: layoutBuilder,
              currentBlocFactory:
                  presentationBuilder.buildPresentation(context, config));
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
