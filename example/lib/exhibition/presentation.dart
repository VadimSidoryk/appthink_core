import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core_example/data/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoped/scoped.dart';

import 'domain.dart';

class ExhibitionObjectsScreen extends StatefulWidget {
  @override
  _ExhibitionObjectsScreenState createState() =>
      _ExhibitionObjectsScreenState();
}

class _ExhibitionObjectsScreenState extends State<ExhibitionObjectsScreen> {
  final _scrollController = ScrollController();
  ExhibitionObjectsBloc _searchBloc;
  final _scrollThreshold = 200.0;

  _ExhibitionObjectsScreenState() {
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Objects list'),
        ),
        body: Center(child: _buildContent(context)));
  }

  Widget _buildContent(BuildContext context) {
    _searchBloc =
        ExhibitionObjectsBloc(context.get<ExhibitionObjectsRepository>());
    return BlocBuilder(
      cubit: _searchBloc,
      // ignore: missing_return
      builder: (BuildContext context, ListState<ObjectModel> state) {
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
                  : ObjectWidget(object: state.value[index]);
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
    _searchBloc.close();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _searchBloc.add(ScrolledToEnd());
    }
  }
}

class ObjectWidget extends StatelessWidget {
  final ObjectModel object;

  const ObjectWidget({Key key, @required this.object}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: object.thumbnailUrls.first,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      title: Text('${object.name}'),
      isThreeLine: true,
      subtitle: Text('${object.description}'),
      dense: true,
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
