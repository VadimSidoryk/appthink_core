import 'package:applithium_core/domain/listing/use_cases.dart';
import 'package:applithium_core/domain/repository.dart';
import 'package:applithium_core/events/events_listener.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/base_widget.dart';
import 'package:applithium_core/presentation/listing/graph.dart';
import 'package:applithium_core/presentation/listing/states.dart';
import 'package:applithium_core_example/listing/domain/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ExampleListingScreen extends BaseWidget<ListingModel,
    ListingScreenState<ItemModel, ListingModel>> {
  static Widget _createWidget(
      BuildContext context,
      ListingScreenState<ItemModel, ListingModel> state,
      EventsListener listener) {
    if (state is ListLoadingState) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (state is ListLoadingFailedState) {
      return Scaffold(body: Center(child: Text("Error")));
    } else {
      final hasItems = state as HasItems<ItemModel, ListingModel>;
      return Scaffold(
          body: Center(
              child: ListView.builder(
                  itemCount: hasItems.data.items.length,
                  itemBuilder: (context, index) => ListTile(
                        title: Text(hasItems.data.items[index].title),
                      ))));
    }
  }

  final ListingUseCases<ItemModel, ListingModel> useCases;

  ExampleListingScreen({required this.useCases}) : super(_createWidget);

  @override
  createBloc(BuildContext context) {
    return AplBloc(
        initialState: ListingScreenState<ItemModel, ListingModel>.initial(),
        repository: AplRepository<ListingModel>(-1),
        domainGraph: createListingGraph<ItemModel, ListingModel>(useCases));
  }
}
