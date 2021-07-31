import 'package:applithium_core/domain/base_bloc.dart';
import 'package:applithium_core/domain/listing/bloc.dart';
import 'package:applithium_core/presentation/base.dart';
import 'package:applithium_core_example/listing/domain.dart';
import 'package:applithium_core_example/listing/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListingScreen
    extends AplWidget<List<ListItemModel>, ListingState<ListItemModel>> {
  ListingScreen() : super(createWidgetForState);

  static int _scrollThreshold = 200;

  @override
  BaseBloc<dynamic, ListingState<ListItemModel>> createBloc(
      BuildContext context, Presenters presenters) {
    return provideListingBloc(context, presenters);
  }

  static Widget createWidgetForState(BuildContext context,
      ListingState<ListItemModel> state, EventsHandler handler) {
    if (state is ListLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is HasList<ListItemModel>) {
      final scrollController = ScrollController();
      scrollController.addListener(() {
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;
        if (maxScroll - currentScroll <= _scrollThreshold) {
          handler.call(ScrolledToEnd());
        }
      });
      final list = (state as HasList<ListItemModel>).list;
      return Scaffold(
          body: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) => ListTile(
                  title: Text(list[index].title),
                  subtitle: Text(list[index].subtitle))));
    } else {
      final error = state is ListLoadingFailed
          ? (state as ListLoadingFailed).error
          : "Undefined error";
      return Text("error $error");
    }
  }
}
