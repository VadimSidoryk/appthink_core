import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ListWidgetState<IM extends Equatable, Bloc extends ListBloc<IM>,
    Screen extends StatefulWidget> extends State<Screen> {
  @protected
  Bloc bloc;

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  ListWidgetState() {
    _scrollController.addListener(onScroll);
  }

  Bloc buildBloc();

  @override
  Widget build(BuildContext context) {
    bloc = buildBloc()..add(BaseEvents.screenShown());
    return BlocBuilder(
      cubit: bloc,
      builder: (BuildContext context, ListState<IM> state) {
        if (state.isLoading) {
          return buildLoading(context);
        } else if (state.value != null && state.error == null) {
          return buildContent(context, state);
        } else {
          return buildError(context,
              state.error != null ? state.error : Exception("Undefined error"));
        }
      },
    );
  }

  Widget buildError(BuildContext context, dynamic e);

  Widget buildLoading(BuildContext context);

  Widget buildContent(BuildContext context, ListState<IM> state) {
    if (state.value.isNotEmpty) {
      return ListView.builder(
            itemCount: state.isEndReached
                ? state.value.length
                : state.value.length + 1,
            itemBuilder: (context, pos) => pos >= state.value.length
                ? buildBottomLoader(context)
                : buildItem(context, state.value[pos]),
            controller: _scrollController,
          );
    } else {
      return buildEmptyView(context);
    }
  }

  Widget buildItem(BuildContext context, IM model);

  Widget buildEmptyView(BuildContext context);

  Widget buildBottomLoader(BuildContext context);

  @protected
  void onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      bloc.add(ScrolledToEnd());
    }
  }
}
