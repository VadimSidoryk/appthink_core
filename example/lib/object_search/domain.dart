import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:applithium_core_example/data/api.dart';
import 'package:applithium_core_example/data/dtos.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ObjectModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> thumbnailUrls;
  final List<String> fullSizeUrls;

  ObjectModel(this.id, this.name, this.description, this.thumbnailUrls,
      this.fullSizeUrls);

  @override
  List<Object> get props => [id];

  factory ObjectModel.fromDTO(ObjectItemDTO dto) {
    return ObjectModel(dto.id, dto.title, dto.description,
        dto.images.map((multiSize) => multiSize.medium.url).toList(),
    dto.images.map((multiSize) => multiSize.large.url).toList());
  }
}

class ExhibitionObjectsRepository extends ListRepository<ObjectModel> {
  final CooperHewittApi _api;

  final String exhibitionId;

  ExhibitionObjectsRepository(this._api, this.exhibitionId) : super(20);

  @override
  Future<List<ObjectModel>> loadItems(
      int startIndex, lastValue, int itemsToLoad) {
    return _api
        .getExhibitionObjects(exhibitionId, startIndex ~/ itemsToLoad + 1, itemsToLoad)
        .then((dtoList) =>
            dtoList.map((dto) => ObjectModel.fromDTO(dto)).toList());
  }
}

class ObjectsListBloc extends ListBloc<ObjectModel, ObjectsListEvent> {
  final ExhibitionObjectsRepository _repository;

  ObjectsListBloc(this._repository) : super(_repository);
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
