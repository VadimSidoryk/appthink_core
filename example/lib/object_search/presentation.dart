import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core_example/projects/data_api.dart';
import 'package:applithium_core_example/projects/domain.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  ObjectsListBloc _projectsBloc;
  final _scrollThreshold = 200.0;

  _HomePageState() {
    _scrollController.addListener(_onScroll);

    final api = CooperHewittApiImpl();
    final repository = SearchObjectsRepository(api);
    _projectsBloc = ObjectsListBloc(repository);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _projectsBloc,
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
    _projectsBloc.close();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _projectsBloc.add(ScrolledToEnd());
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
        imageUrl: object.thumbnailUrl,
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