import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/presentation/content/events.dart';
import 'package:applithium_core/presentation/content/states.dart';
import 'package:applithium_core/presentation/events.dart';
import 'package:applithium_core/presentation/widget.dart';
import 'package:applithium_core_example/content/domain/model.dart';
import 'package:applithium_core_example/content/domain/use_cases.dart';
import 'package:applithium_core_example/content/presentation/bloc.dart';
import 'package:applithium_core_example/content/presentation/events.dart';
import 'package:bloc/src/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';


class ExampleContentScreen extends StatefulWidget {

  final Function() backClicked;
  final ExampleContentUseCases useCases;

  const ExampleContentScreen({Key? key, required this.backClicked, required this.useCases}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ExampleContentState();
  }
}

class _ExampleContentState extends StateWithBloc<ExampleContentScreen, ContentScreenState<ExampleContentModel>> {

  @override
  Bloc<WidgetEvents, ContentScreenState<ExampleContentModel>> createBloc(BuildContext context) {
    return ExampleContentBloc(widget.useCases);
  }

  @override
  Widget createWidgetForState(state) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
              color: Colors.black,
              onPressed: widget.backClicked,
            )),
        body: Center(child: _createBody(state)));
  }


  Widget _createBody(
      ContentScreenState<ExampleContentModel> state) {
    if (state is ContentLoadingState<ExampleContentModel>) {
      return CircularProgressIndicator();
    } else if (state is ContentLoadFailedState<ExampleContentModel>) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Failed, ${state.error}"),
          OutlinedButton(
            child: Text("Reload"),
            onPressed: () => this.onNewEvent(BaseContentEvents.reload()),
          )
        ],
      );
    } else {
      state as HasContent<ExampleContentModel>;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(state.data.title),
          Text(state.data.likes.toString()),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                  child: Text("+"),
                  onPressed: () => this.onNewEvent(ExampleContentEvents.addLike())),
              OutlinedButton(
                  child: Text("-"),
                  onPressed: () => this.onNewEvent(ExampleContentEvents.removeLike()))
            ],
          )
        ],
      );
    }
  }


}
