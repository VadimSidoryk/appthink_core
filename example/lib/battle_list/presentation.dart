import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core_example/battle_details/presentation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:applithium_core/scopes/extensions.dart';

import 'domain.dart';

class TopBattlesListPage extends StatefulWidget {

  const TopBattlesListPage();

  @override
  State<StatefulWidget> createState() {
    return _TopBattlesListPageState();
  }
}

class _TopBattlesListPageState extends State<TopBattlesListPage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  TopBattlesBloc _bloc;

  _TopBattlesListPageState() {
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    _bloc = TopBattlesBloc(context.get());
    return BlocBuilder(
      cubit: _bloc,
      builder: (BuildContext context, ListState<BattleLiteModel> state) {
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.error != null) {
          return Center(
            child: Text('failed to fetch battles'),
          );
        }

        if (state.value.isEmpty) {
          return Center(
            child: Text('no battles'),
          );
        }
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return index >= state.value.length
                ? BottomLoader()
                : BattleWidget(state.value[index]);
          },
          itemCount:
              state.isEndReached ? state.value.length : state.value.length + 1,
          controller: _scrollController,
        );
      },
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _bloc.add(ScrolledToEnd());
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}

class BattleWidget extends StatelessWidget {
  final BattleLiteModel _model;

  const BattleWidget(this._model);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(children: [
        Padding(
            child: ParticipantWidget(_model.participant2),
            padding: EdgeInsets.only(left: 25)),
        Padding(
          child: ParticipantWidget(_model.participant1),
          padding: EdgeInsets.only(right: 25),
        )
      ]),
      title: Text(
        "${_model.participant1.displayName} VS ${_model.participant2.displayName}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text("Waiting"),
      onTap: () => Navigator.pushNamed(context, BattleDetailsScreen.routeName,
          arguments: _model),
      dense: true,
    );
  }
}

class ParticipantWidget extends StatelessWidget {
  final ParticipantModel _model;

  const ParticipantWidget(this._model);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _model.thumbnailUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
