import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/events/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef BlocFactory<M, S extends BaseState<M>> = BaseBloc<M, S> Function(
    BuildContext, Presenters);

typedef EventsHandler = Function(AplEvent);

typedef StatefulWidgetFactory<M, S extends BaseState<M>> = Widget Function(BuildContext, S, EventsHandler listener);


class AplPresentationState<M, S extends BaseState<M>, W extends StatefulWidget> extends State<W> {
  late BaseBloc<M, S> _bloc;

  final BlocFactory<M, S> blocFactory;
  final StatefulWidgetFactory<M, S> widgetFactory;

  AplPresentationState({required this.blocFactory, required this.widgetFactory});

  @override
  Widget build(BuildContext context) {
    _bloc = blocFactory.call(context, _buildPresenters(context));
    _bloc..add(BaseEvents.screenCreated());
    return BlocBuilder<BaseBloc<M, S>, S>(
        bloc: _bloc, builder: (context, state) => widgetFactory.call(context, state, onNewEvent));
  }

  void onNewEvent(AplEvent event) {
    if(event is BaseEvents) {
      _bloc.add(event);
    }
  }

  Presenters _buildPresenters(BuildContext context) {
    return Presenters(dialogPresenter: _showDialog, toastPresenter: _showToast);
  }

  Future<dynamic> _showDialog(String dialogPath) async {
    // return showDialog(
    //     context: context,
    //     builder: (context) {
    //       final config = context.get<ApplicationConfig>().getFor(dialogPath);
    //       final typeToBlocFactoryProvider =
    //           context.get<Map<String, AplPresentationBuilder>>();
    //       final presentationBuilder = typeToBlocFactoryProvider[config.type]!;
    //       return AplPresentation(
    //           stateToUI: config.stateToUI,
    //           layoutBuilder: layoutBuilder,
    //           currentBlocFactory:
    //               presentationBuilder.buildPresentation(context, config));
    //     });
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
