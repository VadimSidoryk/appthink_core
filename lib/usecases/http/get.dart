import 'dart:convert';

import 'package:applithium_core/networking/errors.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:http/http.dart';

class GetRequestParams {
  final String? path;
  final Map<String, String>? params;

  GetRequestParams({this.path, this.params});
}

UseCase<void, O, GetRequestParams> httpGet<I, O>({required String staticUrl, Map<String, String>? headers, required O Function(dynamic) builder}) {
  return (_, params) async {
    final response;

    final pathString = Uri(path: params.path).path;
    final paramsString = Uri(queryParameters: params.params).query;

    final uri = Uri.parse("$staticUrl/$pathString?$paramsString");

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
  };
}

