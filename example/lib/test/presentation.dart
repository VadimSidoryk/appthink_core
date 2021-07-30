import 'package:applithium_core/domain/content/bloc.dart';
import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/presentation/base.dart';
import 'package:applithium_core_example/test/domain.dart';
import 'package:applithium_core_example/test/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AplPresentationState<TestViewModel, ContentState<TestViewModel>,
            TestWidget>(
        blocFactory: (context, presenters) => ContentBloc(
            repository: AplRepository<TestViewModel>(1000),
            presenters: presenters,
            load: testLoad,
            customGraph: testGraph),
        widgetFactory: (context, state, handler) {
          if (state is ContentLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ContentChanged) {
            final model = (state as ContentChanged<TestViewModel>).data;
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
                          ElevatedButton(
                              child: Text("remove"),
                              onPressed: () =>
                                  handler.call(TestScreenEvents.likeRemoved())),
                          ElevatedButton(
                              child: Text("add"),
                              onPressed: () =>
                                  handler.call(TestScreenEvents.likeAdded())),
                        ],
                      ))
                ],
              ),
            ));
          } else if (state is ContentFailed) {
            final error = (state as ContentFailed).error;
            return Center(child: Text("failed $error"));
          } else {
            return Spacer();
          }
        });
  }
}
