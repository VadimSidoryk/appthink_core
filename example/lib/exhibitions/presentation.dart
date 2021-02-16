import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core_example/exhibition/presentation.dart';
import 'package:applithium_core_example/exhibitions/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoped/scoped.dart';

class ExhibitionsScreen extends StatefulWidget {
  @override
  _ExhibitionsScreenState createState() => _ExhibitionsScreenState();
}

class _ExhibitionsScreenState extends State<ExhibitionsScreen> {
  final _scrollController = ScrollController();
  ExhibitionsBloc _bloc;
  final _scrollThreshold = 200.0;

  _ExhibitionsScreenState() {
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Exhibitions list'),
        ),
        body: Center(child: _buildContent(context)));
  }

  Widget _buildContent(BuildContext context) {
    _bloc = ExhibitionsBloc(context.get<ExhibitionsRepository>());
    return BlocBuilder(
      cubit: _bloc,
      // ignore: missing_return
      builder: (BuildContext context, ListState<ExhibitionModel> state) {
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.error != null) {
          return Center(
            child: Text('failed to fetch objects'),
          );
        }
        if (state.value != null) {
          if (state.value.isEmpty) {
            return Center(
              child: Text('no objects'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.value.length
                  ? BottomLoader()
                  : ExhibitionWidget(model: state.value[index]);
            },
            itemCount: state.isEndReached
                ? state.value.length
                : state.value.length + 1,
            controller: _scrollController,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _bloc.add(ScrolledToEnd());
    }
  }
}

class ExhibitionWidget extends StatelessWidget {
  final ExhibitionModel model;

  const ExhibitionWidget({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: ListTile(
      title: Text('${model.name}'),
      dense: true,
    ),
    onTap: () => Navigator.pushNamed(context, '/exhibition_objects'));
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