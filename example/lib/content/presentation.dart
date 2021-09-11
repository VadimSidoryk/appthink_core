import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/domain/content/domain.dart';
import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/presentation/graph_based.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'domain.dart';
import 'model.dart';

class ContentScreen
    extends GraphBasedWidget<ContentViewModel, ContentState<ContentViewModel>> {
  ContentScreen() : super(createWidgetForState);

  static Widget createWidgetForState(BuildContext context,
      ContentState<ContentViewModel> state, EventsListener eventsHandler) {
    if (state is ContentLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (state is ContentChanged) {
      final model = (state as ContentChanged<ContentViewModel>).data;
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
      if (state is ContentFailed) {
        error = (state as ContentFailed).error;
      } else {
        error = "Undefined";
      }
      return Scaffold(body: Center(child: Text("failed $error")));
    }
  }

  @override
  DomainGraph<ContentViewModel, ContentState<ContentViewModel>>
      get domainGraph => contentGraph;

  @override
  ContentState<ContentViewModel> getInitialState() {
    return ContentState.initial();
  }
}
