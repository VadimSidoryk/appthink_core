import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/domain/content/events.dart';
import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/.presentation/graph_based.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../.domain/model.dart';
import '../.domain/use_cases.dart';
import 'graph.dart';

class ContentScreen
    extends BaseWidget<ContentViewModel, ContentScreenState<ContentViewModel>> {

  final ContentScreenUseCases useCases;

  ContentScreen({required this.useCases}) : super(createWidgetForState);

  static Widget createWidgetForState(BuildContext context,
      ContentScreenState<ContentViewModel> state, EventsListener eventsHandler) {
    if (state is ContentLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (state is DisplayContent) {
      final model = (state as DisplayContent<ContentViewModel>).data;
      return Scaffold(
          body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("title: ${model.title}"),
            Text("description: ${model.description}"),
            Text("likes: ${model.likes}"),
            Container(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton(
                          child: Text("remove"),
                          onPressed: () => eventsHandler
                              .onNewEvent(ContentScreenEvents.likeRemoved())),
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        child: ElevatedButton(
                            child: Text("add"),
                            onPressed: () => eventsHandler
                                .onNewEvent(ContentScreenEvents.likeAdded()))),
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  child: Text("Force update"),
                  onPressed: () =>
                      eventsHandler.onNewEvent(ContentScreenEvents.forceUpdate()),
                ))
          ],
        ),
      ));
    } else {
      final error;
      if (state is ContentLoadFailed) {
        error = (state as ContentLoadFailed).error;
      } else {
        error = "Undefined";
      }
      return Scaffold(body: Center(child: Text("failed $error")));
    }
  }

  @override
  DomainGraph<ContentViewModel, ContentScreenState<ContentViewModel>>
      get domainGraph => createContentScreenGraph(useCases);

  @override
  ContentScreenState<ContentViewModel> getInitialState() {
    return ContentScreenState.initial();
  }
}
