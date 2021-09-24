import 'package:applithium_core/domain/listing/use_cases.dart';
import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/presentation/base_state.dart';
import 'package:applithium_core/presentation/events.dart';
import 'package:applithium_core/presentation/listing/bloc.dart';
import 'package:applithium_core/presentation/listing/states.dart';
import 'package:applithium_core_example/listing/domain/model.dart';
import 'package:bloc/src/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ExampleListingScreen extends StatefulWidget {

  final ListingUseCases<ExampleItemModel, ExampleListingModel> useCases;

  ExampleListingScreen({required this.useCases, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ExampleListingState();
  }

}

class _ExampleListingState extends StateWithBloc<ExampleListingScreen, ListingScreenState<ExampleItemModel, ExampleListingModel>> {

  @override
  Widget createWidgetForState(ListingScreenState<ExampleItemModel, ExampleListingModel> state, EventsListener listener) {
    if (state is ListLoadingState) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (state is ListLoadingFailedState) {
    return Scaffold(body: Center(child: Text("Error")));
    } else {
    final hasItems = state as HasItems<ExampleItemModel, ExampleListingModel>;
    return Scaffold(
    body: Center(
    child: ListView.builder(
    itemCount: hasItems.data.items.length,
    itemBuilder: (context, index) => ListTile(
    title: Text(hasItems.data.items[index].title),
    ))));
    }
  }

  @override
  Bloc<WidgetEvents, ListingScreenState<ExampleItemModel, ExampleListingModel>> createBloc(BuildContext context) {
    return ListingBloc(widget.useCases);
  }
}
