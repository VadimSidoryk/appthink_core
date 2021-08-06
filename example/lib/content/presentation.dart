import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/domain/content/bloc.dart';
import 'package:applithium_core/presentation/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'domain.dart';
import 'model.dart';

class ContentScreen
    extends AplWidget<ContentViewModel, ContentState<ContentViewModel>> {
  ContentScreen() : super(createWidgetForState);

  @override
  BaseBloc<ContentViewModel, ContentState<ContentViewModel>> createBloc(
      BuildContext context, Presenters presenters) {
    return provideContentBloc(context, presenters);
  }

  static Widget createWidgetForState(BuildContext context,
      ContentState<ContentViewModel> state, EventsHandler eventsHandler) {
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
                              .call(ContentScreenEvents.likeRemoved())),
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        child: ElevatedButton(
                            child: Text("add"),
                            onPressed: () => eventsHandler
                                .call(ContentScreenEvents.likeAdded()))),
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  child: Text("Force update"),
                  onPressed: () =>
                      eventsHandler.call(ContentScreenEvents.forceUpdate()),
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
}
