import 'dart:convert';

import 'package:applithium_core/logs/logger.dart';
import 'package:http/http.dart';

import 'http_client.dart';
import 'http_errors.dart';

class HttpClientImpl extends HttpClient {
  final String _host;
  final Logger _logger;

  HttpClientImpl(this._host, this._logger);

  @override
  Future<dynamic> getImpl(String path,
      {String query = "", Map<String, String> headers = const {}}) async {
    Response response;

    final querySb = StringBuffer(_host);
    if(path != null && path.length > 1 && path[0] != "/") {
      querySb.write("/");
    }
    querySb.write(path);

    if (query != null && query.length > 0) {
      querySb.write("?");
      querySb.write(query);
    }

    _logger.log("request get query = " + querySb.toString());
    _logger.log("request get headers = " + headers.toString());

    try {
      response = await get(querySb.toString(), headers: headers);
    } catch (e) {
      _logger.log("error = " + e.toString());
      throw NotConnectedError();
    }

    _logger.log("response get body = " + response.body.toString());
    _logger.log("response get code = " + response.statusCode.toString());
    _logger.log("response get headers = " + response.headers.toString());

    if (response.statusCode != 200) {
      throw RemoteServerError();
    }

    return response.body;
  }

  @override
  Future<dynamic> postImpl(String path, Map<String, dynamic> body,
      {Map<String, String> headers = const { 'content-type' : 'application/json' }}) async {
    Response response;

    final querySb = StringBuffer(_host);
    if(path != null && path.length > 1 && path[0] != "/") {
      querySb.write("/");
    }
    querySb.write(path);

    _logger.log("request post query = " + querySb.toString());
    _logger.log("request post headers = " + headers.toString());
    _logger.log("request post body = " + body.toString());

    try {
      response = await post(querySb.toString(), headers: headers, body: json.encode(body));
    } catch (e) {
      _logger.log("error post = " + e.toString());
      throw NotConnectedError();
    }

    _logger.log("response post body = " + response.body.toString());
    _logger.log("response post code = " + response.statusCode.toString());
    _logger.log("response post headers = " + response.headers.toString());

    if (response.statusCode != 200) {
      throw RemoteServerError();
    }

    return response.body;
  }
}