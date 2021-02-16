import 'package:applithium_core/networking/http_client_impl.dart';

import 'dtos.dart';



abstract class CooperHewittApi {
  Future<List<ObjectItemDTO>> getExhibitionObjects(
      String exhibitionId, int page, int itemsPerPage);

  Future<List<ExhibitionItemDTO>> getExhibitions(int page, int itemsPerPage);

  Future<List<ObjectItemDTO>> getObjectsByQuery(
      String query, int page, int itemsPerPage);

  Future<ObjectItemDTO> getObjectInfo(String objectId);
}

class CooperHewittApiImpl extends CooperHewittApi {
  final String _token;
  final _httpClient =
  HttpClientFirstImpl("https://api.collection.cooperhewitt.org/rest");

  CooperHewittApiImpl(this._token);

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

  @override
  Future<ObjectItemDTO> getObjectInfo(String objectId) {
    return _httpClient.getImpl("/", queryParams: {
      "method": "cooperhewitt.objects.getInfo",
      "object_id ": objectId,
      "access_token": _token
    }).then((json) {
      return ObjectItemDTO.fromJson(json["object"]);
    });
  }
}
