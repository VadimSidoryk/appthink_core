import 'package:applithium_core/networking/errors.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:applithium_core/usecases/http/get.dart';
import 'package:http/http.dart';

class PostRequestParams extends GetRequestParams {
  final Object? body;

  PostRequestParams({this.body, String? path, Map<String, String>? params})
      : super(path: path, params: params);
}

UseCaseWithParams<void, int, PostRequestParams> httpPost(
    {required String staticUrl, Map<String, String>? headers}) {
  return (_, params) async {
    final response;
    final pathString = Uri(path: params.path).path;
    final paramsString = Uri(queryParameters: params.params).query;
    final uri = Uri.parse("$staticUrl/$pathString?$paramsString");
    try {
      response = await post(uri, body: params.body, headers: headers);
      if (response.statusCode != 200) {
        throw RemoteServerError(uri, response.statusCode, response.bodyJson);
      }
    } catch (e) {
      throw NotConnectedError(uri, DateTime
          .now()
          .millisecondsSinceEpoch);
    }

    return response.statusCode;
  };
}
