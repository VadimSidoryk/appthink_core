import 'dart:convert';

import 'package:applithium_core/networking/errors.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:http/http.dart';

class HttpGetUseCase<T> extends UseCase<T> {
  final Uri uri;
  final Map<String, String> headers;

  HttpGetUseCase(this.uri, {this.headers = const {}});

  @override
  Stream<T> invokeImpl({T? state}) async* {
    final response;
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
