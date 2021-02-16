import 'package:applithium_core/networking/http_client_impl.dart';

import 'dtos.dart';



abstract class CooperHewittApi {
  Future<List<ObjectItemDTO>> getExhibitionObjects(
      String exhibitionId, int page, int itemsPerPage);

  Future<List<ExhibitionItemDTO>> getExhibitions(int page, int itemsPerPage);

  Future<List<ObjectItemDTO>> getObjectsByQuery(
      String query, int page, int itemsPerPage);
}

class CooperHewittApiImpl extends CooperHewittApi {
  final _token = "77a9aa7138f7c5bcc8a2fc3842681730";
  final _httpClient =
  HttpClientFirstImpl("https://api.collection.cooperhewitt.org/rest");

  @override
  Future<List<ExhibitionItemDTO>> getExhibitions(int page, int itemsPerPage) {
    return _httpClient.getImpl("/", queryParams: {
      "method": "cooperhewitt.exhibitions.getList",
      "page": page.toString(),
      "per_page": itemsPerPage.toString(),
      "access_token": _token
    }).then((json) {
      final List<dynamic> items = json["exhibitions"];
      return items
          .map((itemJson) => ExhibitionItemDTO.fromJson(itemJson))
          .toList();
    });
  }

  @override
  Future<List<ObjectItemDTO>> getExhibitionObjects(
      String exhibitionId, int page, int itemsPerPage) {
    return _httpClient.getImpl("/", queryParams: {
      "method": "cooperhewitt.exhibitions.getObjects",
      "exhibition_id": exhibitionId,
      "page": page.toString(),
      "per_page": itemsPerPage.toString(),
      "access_token": _token
    }).then((json) {
      final List<dynamic> items = json["objects"];
      return items.map((itemJson) => ObjectItemDTO.fromJson(itemJson)).toList();
    });
  }

  @override
  Future<List<ObjectItemDTO>> getObjectsByQuery(
      String query, int page, int itemsPerPage) {
    return _httpClient.getImpl("/", queryParams: {
      "method": "cooperhewitt.exhibitions.getObjects",
      "query": query,
      "page": page.toString(),
      "per_page": itemsPerPage.toString(),
      "access_token": _token
    }).then((json) {
      final List<dynamic> items = json["objects"];
      return items.map((itemJson) => ObjectItemDTO.fromJson(itemJson)).toList();
    });
  }
}
