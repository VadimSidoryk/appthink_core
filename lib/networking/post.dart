import 'package:applithium_core/utils/either.dart';
import 'package:http/http.dart';

import 'errors.dart';

Future<Either<int>> httpPost(
    {required String url,
    Map<String, String>? headers,
    Map<String, String>? params,
    Object? body}) async {
  final response;
  final paramsString;
  final uri;

  try {
    paramsString = Uri(queryParameters: params).query;
    uri = Uri.parse("$url?$paramsString");
  } catch (e) {
    return Either.withError(e);
  }

  try {
    response = await post(uri, body: body, headers: headers);
    if (response.statusCode != 200) {
      return Either.withError(
          RemoteServerError(uri, response.statusCode, response.bodyJson));
    }
  } catch (e) {
    return Either.withError(
        NotConnectedError(uri, DateTime.now().millisecondsSinceEpoch));
  }

  return Either.withValue(response.statusCode);
}
