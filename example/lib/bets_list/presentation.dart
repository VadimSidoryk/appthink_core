import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core_example/bets_list/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:applithium_core/scopes/extensions.dart';

class UserBetsListPage extends StatefulWidget {
  const UserBetsListPage();

  @override
  State<StatefulWidget> createState() {
    return _BetsListState();
  }
}

class _BetsListState extends State<UserBetsListPage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  BetsListBloc _bloc;

  _BetsListState() {
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BetsListBloc(context.get());
    return BlocBuilder(
      cubit: _bloc,
      builder: (BuildContext context, ListState<BetLiteModel> state) {
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.error != null) {
          return Center(
            child: Text('failed to fetch bets'),
          );
        }

        if (state.value.isEmpty) {
          return Center(
            child: Text('no bets'),
          );
        }
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return index >= state.value.length
                ? BottomLoader()
                : BetWidget(state.value[index]);
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

class BetWidget extends StatelessWidget {
  final BetLiteModel _model;

  const BetWidget(this._model);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:  Text(
        "${_model.cashAmount}",
        style: TextStyle(
            color: Colors.green, fontWeight: FontWeight.bold, fontSize: 21),
      ),
      title: Text(
        _model.battleResultTitle,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(_model.battleTitle),
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
