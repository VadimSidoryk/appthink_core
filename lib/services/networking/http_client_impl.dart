import 'dart:convert';

import 'package:applithium_core/logs/extension.dart';
import 'package:http/http.dart';

import 'http_client.dart';
import 'http_errors.dart';

class HttpClientFirstImpl extends HttpClient {
  final String _host;

  HttpClientFirstImpl(this._host);

  @override
  Future<dynamic> getImpl(String path,
      {Map<String, String> queryParams = const {},
      Map<String, String> headers = const {}}) async {
    Response response;

    try {
      final uri = Uri(host: _host, path: path, queryParameters: queryParams);
      log("request get uri = " + uri.toString());
      log("request get headers = " + headers.toString());

      response = await get(uri, headers: headers);
    } catch (e) {
      logError(e);
      throw NotConnectedError();
    }

    log("response get body = " + response.body.toString());
    log("response get code = " + response.statusCode.toString());
    log("response get headers = " + response.headers.toString());

    if (response.statusCode != 200) {
      throw RemoteServerError();
    }

    return json.decode(response.body);
  }

  @override
  Future<dynamic> postImpl(String path, Map<String, dynamic> body,
      {Map<String, String> headers = const {
        'content-type': 'application/json'
      }}) async {
    Response response;
    try {
      final uri = Uri(host: _host, path: path);
      log("request post uri = " + uri.toString());
      log("request post headers = " + headers.toString());
      log("request post body = " + body.toString());
      response = await post(uri,
          headers: headers, body: json.encode(body));
    } catch (e) {
      log("error post = " + e.toString());
      throw NotConnectedError();
    }

    log("response post body = " + response.body.toString());
    log("response post code = " + response.statusCode.toString());
    log("response post headers = " + response.headers.toString());

    if (response.statusCode != 200) {
      throw RemoteServerError();
    }

    return response.body;
  }
}
