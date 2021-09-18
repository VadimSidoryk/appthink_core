import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/base_widget.dart';
import 'package:applithium_core/presentation/content/events.dart';
import 'package:applithium_core/presentation/content/graph.dart';
import 'package:applithium_core/presentation/content/states.dart';
import 'package:applithium_core/presentation/graph.dart';
import 'package:applithium_core_example/content/domain/model.dart';
import 'package:applithium_core_example/content/domain/use_cases.dart';
import 'package:applithium_core_example/content/presentation/graph.dart';
import 'package:bloc/src/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'events.dart';

class ExampleContentScreen extends BaseWidget<ExampleContentModel,
    ContentScreenState<ExampleContentModel>> {
  static Widget _createWidget(
      BuildContext context,
      ContentScreenState<ExampleContentModel> state,
      EventsListener listener,
      Function() backClicked) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
          color: Colors.black,
          onPressed: backClicked,
        )),
        body: Center(
            child: state.fold(
                (ContentLoadingState _) => CircularProgressIndicator(),
                (ContentLoadFailedState failed) => Column(
                      children: [
                        Text("Failed, ${failed.error}"),
                        OutlinedButton(
                          child: Text("Reload"),
                          onPressed: () =>
                              listener.onNewEvent(ReloadRequested()),
                        )
                      ],
                    ),
                (DisplayContentState<ExampleContentModel> state) => Column(
                      children: [
                        Text(state.data.title),
                        Text(state.data.description),
                        Row(
                          children: [
                            OutlinedButton(
                                child: Text("+"),
                                onPressed: () =>
                                    listener.onNewEvent(AddLike())),
                            OutlinedButton(
                                child: Text("-"),
                                onPressed: () =>
                                    listener.onNewEvent(RemoveLike()))
                          ],
                        )
                      ],
                    ),
                (ContentUpdatingState _) => CircularProgressIndicator())));
  }

  final Function() backClicked;
  final ExampleContentUseCases useCases;

  ExampleContentScreen({required this.backClicked, required this.useCases})
      : super((c, s, l) => _createWidget(c, s, l, backClicked));

  @override
  Bloc<WidgetEvents, ContentScreenState<ExampleContentModel>> createBloc(
      BuildContext context) {
    return AplBloc(
        initialState: ContentScreenState.initial(),
        repository: AplRepository(-1),
        domainGraph: combine2(
            createContentGraph(useCases), createExampleContentGraph(useCases)));
  }
}
