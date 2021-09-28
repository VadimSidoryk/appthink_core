import 'dart:convert';

import 'package:applithium_core/networking/errors.dart';
import 'package:http/http.dart';

Future<O> httpGet<I, O>({
  required String url,
  Map<String, String>? headers,
  Map<String, String>? params,
  required O Function(dynamic) builder}) async {
    final response;
    final paramsString = Uri(queryParameters: params).query;

    final uri = Uri.parse("$url?$paramsString");

    try {
      response = await get(uri, headers: headers);
    } catch (e) {
      throw NotConnectedError(uri, DateTime.now().millisecondsSinceEpoch);
    }

    if (response.statusCode != 200) {
      throw RemoteServerError(uri, response.statusCode, response.bodyJson);
    }

    final data = json.decode(response.bodyJson);
    return builder.call(data);
}

