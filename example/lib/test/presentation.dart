import 'package:applithium_core/domain/content/bloc.dart';
import 'package:applithium_core/presentation/base.dart';
import 'package:applithium_core_example/test/domain.dart';
import 'package:applithium_core_example/test/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:applithium_core/scopes/extensions.dart';

class TestWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AplPresentationState<TestViewModel, ContentState<TestViewModel>, TestWidget>(
      blocFactory: (context, presenters) => ContentBloc(repository: context.get(), presenters: presenters, load: testLoad, customGraph: testGraph),
      widgetFactory: (context, state) {

      }
    );
  }

}
