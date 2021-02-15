import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:applithium_core_example/data/api.dart';
import 'package:applithium_core_example/data/dtos.dart';
import 'package:equatable/equatable.dart';

class ObjectModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final String fullSizeUrl;

  ObjectModel(this.id, this.name, this.description, this.thumbnailUrl,
      this.fullSizeUrl);

  @override
  List<Object> get props => [id];

  factory ObjectModel.fromDTO(ObjectItemDTO dto) {
    return ObjectModel(dto.id, dto.title, dto.description, dto.images.small.url,
        dto.images.large.url);
  }
}

class SearchObjectsRepository extends ListRepository<ObjectModel> {
  final CooperHewittApi _api;

  String _searchQuery;

  SearchObjectsRepository(this._api) : super(20);

  Future<bool> searchQueryChanged(String query) {
    _searchQuery = query;
    return updateData(true);
  }

  @override
  Future<List<ObjectModel>> loadItems(
      int startIndex, lastValue, int itemsToLoad) {
    return _api
        .getObjectsByQuery(_searchQuery, startIndex ~/ itemsToLoad, itemsToLoad)
        .then((dtoList) =>
            dtoList.map((dto) => ObjectModel.fromDTO(dto)).toList());
  }
}

class ObjectsListBloc extends ListBloc<ObjectModel, ObjectsListEvent> {
  final SearchObjectsRepository _repository;

  ObjectsListBloc(this._repository) : super(_repository);

  @override
  Stream<ListState<ObjectModel>> mapCustomEventToState(
      ObjectsListEvent event) async* {
    if (event is SearchQueryChanged) {
      _repository.searchQueryChanged(event._searchQuery);
    }
  }
}

class ObjectsListEvent extends BaseListEvent {
  ObjectsListEvent(String analyticTag) : super(analyticTag);
}

class SearchQueryChanged extends ObjectsListEvent {
  final String _searchQuery;

  @override
  Map<String, Object> get analyticParams => {"query": _searchQuery};

  SearchQueryChanged(this._searchQuery) : super("query_text_changed");
}
