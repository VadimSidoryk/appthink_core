import 'package:applithium_core/utils/either.dart';
import 'package:http/http.dart';

import 'errors.dart';
import 'parser.dart';

Future<Either<O>> httpGet<I, O>({
  required String url,
  Map<String, String>? headers,
  Map<String, String>? params,
  required Parser<O> resultParser}) async {
    final Response response;
    final paramsString;
    final uri;
    try {
      if(params?.isNotEmpty == true) {
        paramsString = Uri(queryParameters: params).query;
        if(!url.contains("?")) {
          uri = Uri.parse("$url?$paramsString");
        } else {
          uri = Uri.parse("$url&$paramsString");
        }
      } else {
        uri = url;
      }

    } catch(e) {
      return Either.withError(e);
    }

    try {
      response = await get(uri, headers: headers);
    } catch (e) {
      return Either.withError(NotConnectedError(uri, DateTime.now().millisecondsSinceEpoch));
    }

    if (response.statusCode != 200) {
      return Either.withError(RemoteServerError(uri, response.statusCode, response.body));
    }

    try {
      final result = resultParser(response.body);
      return Either.withValue(result);
    } catch (e){
      return Either.withError(e);
    }
}

