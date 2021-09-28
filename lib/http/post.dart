import 'package:applithium_core/networking/errors.dart';
import 'package:http/http.dart';

Future<int> httpPost(
    {required String url,
    Map<String, String>? headers,
    Map<String, String>? params,
    Object? body}) async {
  final response;
  final paramsString = Uri(queryParameters: params).query;
  final uri = Uri.parse("$url?$paramsString");
  try {
    response = await post(uri, body: body, headers: headers);
    if (response.statusCode != 200) {
      throw RemoteServerError(uri, response.statusCode, response.bodyJson);
    }
  } catch (e) {
    throw NotConnectedError(uri, DateTime.now().millisecondsSinceEpoch);
  }

  return response.statusCode;
}
