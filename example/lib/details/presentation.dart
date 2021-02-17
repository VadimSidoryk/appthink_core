import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core_example/details/domain.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoped/scoped.dart';

class BattleDetailsScreen extends StatefulWidget {
  static const routeName = "/battle_details";

  @override
  State<StatefulWidget> createState() {
    return _BattleDetailsScreenState();
  }
}

class _BattleDetailsScreenState extends State<BattleDetailsScreen> {
  BattleDetailsBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = BattleDetailsBloc(context.get());
    return Scaffold(
        body: BlocBuilder(
            cubit: _bloc,
            // ignore: missing_return
            builder:
                (BuildContext context, ContentState<BattleDetailsModel> state) {
              if (state.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state.error != null) {
                return Center(
                  child: Text('failed to fetch battle details'),
                );
              }
              return _BattleDetailsWidget(state.value);
            }));
  }
}

class _BattleDetailsWidget extends StatelessWidget {
  final BattleDetailsModel _model;

  const _BattleDetailsWidget(this._model);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(child: CachedNetworkImage(imageUrl: _model.participant1.fullSizeImage), flex: 1,),
        Flexible(child: CachedNetworkImage(imageUrl: _model.participant2.fullSizeImage), flex: 1,)
      ],
    );
  }
}
