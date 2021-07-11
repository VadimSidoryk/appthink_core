import 'dart:convert';

import 'package:applithium_core/networking/errors.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:http/http.dart';

const HTTP_GET_PARAMS_KEY = "params";
const HTTP_GET_PATH_KEY = "path";
const HTTP_GET_HEADERS_KEY = "headers";

class HttpGetUseCase<T> extends UseCase<T> {
  final String staticUri;
  final Map<String, String> staticHeaders;

  HttpGetUseCase(this.staticUri, {this.staticHeaders = const {}});

  @override
  Stream<T> invokeImpl(T? state, Map<String, dynamic> params) async* {
    final response;

    final pathString = Uri(path: params[HTTP_GET_PATH_KEY] ?? {}).path;
    final paramsString = Uri(queryParameters: params[HTTP_GET_PARAMS_KEY] ?? {}).query;

    final uri = Uri.parse("$staticUri/$pathString?$paramsString");

    final headers = staticHeaders..addAll(params[HTTP_GET_PARAMS_KEY] ?? {});

    try {
      response = await get(uri, headers: headers);
    } catch (e) {
      throw NotConnectedError(uri, DateTime.now().millisecondsSinceEpoch);
    }

    if (response.statusCode != 200) {
      throw RemoteServerError(uri, response.statusCode, response.bodyJson);
    }
    yield json.decode(response.bodyJson) as T;
  }
}
