import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/events/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef WidgetForStateFactory<M, S extends BaseState<M>> = Widget Function(BuildContext, S, EventsHandler);

typedef EventsHandler = Function(AplEvent);

abstract class BaseWidget<M, S extends BaseState<M>> extends StatelessWidget {

  late final Bloc<BaseEvents, S> _bloc;
  final WidgetForStateFactory<M, S> widgetForStateFactory;

  BaseWidget(this.widgetForStateFactory, {Key? key}) : super(key: key);

  @protected
  Bloc<BaseEvents, S> createBloc(BuildContext context, Presenters presenters);

  @override
  Widget build(BuildContext context) {
    _bloc = createBloc(context, _buildPresenters(context));
    _bloc..add(BaseEvents.screenCreated());
    return BlocBuilder<Bloc<BaseEvents, S>, S>(
        bloc: _bloc, builder: (context, state) => widgetForStateFactory.call(context, state, onNewEvent));
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

abstract class GraphBasedWidget<M, S extends BaseState<M>> extends BaseWidget<M, S> {

  @protected
  AplRepository<M> repository = AplRepository<M>(-1);

  GraphBasedWidget(WidgetForStateFactory<M, S> widgetForStateFactory) : super(widgetForStateFactory);

  @protected
  S getInitialState();

  @protected
  DomainGraph<M, S> get domainGraph;

  @protected
  Bloc<BaseEvents, S> createBloc(BuildContext context, Presenters presenters) {
    return AplBloc(
        initialState: getInitialState(),
        repository: repository,
        presenters: presenters,
        customGraph: domainGraph
    );
  }
}
