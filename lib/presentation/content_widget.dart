import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ContentWidgetState<VM, Bloc extends ContentBloc<VM>, Screen extends StatefulWidget> extends State<Screen> {

  @protected
  Bloc bloc;
  
  Bloc buildBloc();

  @override
  Widget build(BuildContext context) {
    bloc = buildBloc()..add(BaseEvents.screenShown());
    return BlocBuilder(
      cubit: bloc,
      builder: (BuildContext context, ContentState<VM> state) {
        if (state.isLoading) {
          return buildLoading(context);
        } else if (state.value != null && state.error == null) {
          return buildContent(context, state.value);
        } else {
          return buildError(context, state.error != null ? state.error : Exception("Undefined error"));
        }
      },
    );
  }

  Widget buildError(BuildContext context, dynamic e);

  Widget buildLoading(BuildContext context);

  Widget buildContent(BuildContext context, VM model);

}