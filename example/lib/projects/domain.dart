import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core/networking/http_client_impl.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:equatable/equatable.dart';

import 'data.dart';

class BehanceProjectModel extends Equatable  {
   final String name;
   final String url;
   final String thumbnail;
   final Map<String, String> ownersToIcon;

  BehanceProjectModel(this.name, this.url, this.thumbnail, this.ownersToIcon);

  @override
  List<Object> get props => [url];
}

abstract class BehanceApi {
  Future<List<BehanceProjectModel>> searchForProjects(String searchQuery, int page);
}

class BehanceApiFirstImpl extends BehanceApi {
  
  final httpClient;

  BehanceApiFirstImpl(): httpClient =  HttpClientFirstImpl("https://api.behance.net");

  @override
  Future<List<BehanceProjectModel>> searchForProjects(String searchQuery, int page) {
    return httpClient.getImpl(
        "/v2/projects",
        query: "q=$searchQuery&page=${page + 1}"
    ).then((json) => BehanceProjectListDTO.fromJson(json))
        .then((dto) {
          final result = [];
          for(int i = 0; i < dto.projects.length; i++) {
            final BehanceProjectDTO itemDTO = dto.projects[i];
            result.add(BehanceProjectModel(
              itemDTO.name,
              itemDTO.url,
              itemDTO.covers.medium,
              Map.fromEntries(itemDTO.owners.ownersMap.values.map((owner) => MapEntry(owner.displayName, owner.images.small)))
            ));
          }

    });
  }
}

class BehanceProjectsRepository extends ListRepository<BehanceProjectModel> {
  
  final BehanceApi _api;

  String _searchQuery;

  BehanceProjectsRepository(this._api) : super(12);
  
  Future<bool> searchQueryChanged(String query) {
    _searchQuery = query;
    return updateData(true);
  }

  @override
  Future<List<BehanceProjectModel>> loadItems(int startIndex, lastValue, int itemsToLoad) {
    return _api.searchForProjects(_searchQuery, startIndex ~/ itemsToLoad);
  }
}

class ProjectsListBloc extends ListBloc<BehanceProjectModel, ProjectsListEvent> {
  
  final BehanceProjectsRepository _repository;
  
  ProjectsListBloc(this._repository) : super(_repository);

  @override
  Stream<ListState<BehanceProjectModel>> mapCustomEventToState(ProjectsListEvent event) async* {
    if(event is SearchQueryChanged) {
      _repository.searchQueryChanged(event._searchQuery);
    }
  }
}

class ProjectsListEvent extends BaseListEvent {
  ProjectsListEvent(String analyticTag) : super(analyticTag);
}

class SearchQueryChanged extends ProjectsListEvent {
  final String _searchQuery;
  
  @override
  Map<String, Object> get analyticParams => {"query": _searchQuery};

  SearchQueryChanged(this._searchQuery): super("query_text_changed");
}