import 'dart:convert';

import 'package:applithium_core/either/either.dart';
import 'package:http/http.dart';

import 'errors.dart';

Future<Either<O>> httpGet<I, O>({
  required String url,
  Map<String, String>? headers,
  Map<String, String>? params,
  required O Function(dynamic) builder}) async {
    final response;
    final paramsString;
    final uri;
    try {
      paramsString = Uri(queryParameters: params).query;
      uri = Uri.parse("$url?$paramsString");
    } catch(e) {
      return Either.withError(e);
    }

    try {
      response = await get(uri, headers: headers);
    } catch (e) {
      return Either.withError(NotConnectedError(uri, DateTime.now().millisecondsSinceEpoch));
    }

    if (response.statusCode != 200) {
      return Either.withError(RemoteServerError(uri, response.statusCode, response.bodyJson));
    }

    final data = json.decode(response.bodyJson);
    try {
      final result = builder.call(data);
      return Either.withValue(result);
    } catch (e){
      return Either.withError(e);
    }
}

