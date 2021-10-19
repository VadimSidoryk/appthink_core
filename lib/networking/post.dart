import 'package:applithium_core/utils/either.dart';
import 'package:http/http.dart';

import 'errors.dart';
import 'parser.dart';

Future<Either<T>> httpPost<T>(
    {required String url,
    Map<String, String>? headers,
    Map<String, String>? params,
    Object? body,
    required Parser<T> resultParser}) async {
  final paramsString;
  final uri;

  try {
    paramsString = Uri(queryParameters: params).query;
    uri = Uri.parse("$url?$paramsString");
  } catch (e) {
    return Either.withError(e);
  }

  final Response response;
  try {
    response = await post(uri, body: body, headers: headers);
    if (response.statusCode != 200) {
      return Either.withError(
          RemoteServerError(uri, response.statusCode, response.body));
    }
  } catch (e) {
    return Either.withError(
        NotConnectedError(uri, DateTime.now().millisecondsSinceEpoch));
  }

  try {
    final result = resultParser(response.body);
    return Either.withValue(result);
  } catch(e) {
    return Either.withError(e);
  }
}
