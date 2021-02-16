import 'dart:convert';

import 'package:applithium_core/logs/default_logger.dart';
import 'package:applithium_core/logs/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import 'http_client.dart';
import 'http_errors.dart';

class HttpClientFirstImpl extends HttpClient {
  final String _host;

  @protected
  final Logger logger;

  HttpClientFirstImpl(this._host, {this.logger = const DefaultLogger()});

  @override
  Future<dynamic> getImpl(String path,
      {Map<String, String> queryParams = const {},
      Map<String, String> headers = const {}}) async {
    Response response;

    final querySb = StringBuffer(_host);
    if (path != null && path.length > 1 && path[0] != "/") {
      querySb.write("/");
    }
    querySb.write(path);

    if (queryParams != null && queryParams.length > 0) {
      querySb.write("?");
      var iterator = queryParams.entries.iterator;
      var isFirst = true;
      while(iterator.moveNext()) {
        if(!isFirst) {
          querySb.write("&");
        }
        isFirst = false;

        final entry = iterator.current;
        querySb.write("${entry.key}=${entry.value}");
      }
    }

    logger.log("request get query = " + querySb.toString());
    logger.log("request get headers = " + headers.toString());

    try {
      response = await get(querySb.toString(), headers: headers);
    } catch (e) {
      logger.error(e);
      throw NotConnectedError();
    }

    logger.log("response get body = " + response.body.toString());
    logger.log("response get code = " + response.statusCode.toString());
    logger.log("response get headers = " + response.headers.toString());

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

    final querySb = StringBuffer(_host);
    if (path != null && path.length > 1 && path[0] != "/") {
      querySb.write("/");
    }
    querySb.write(path);

    logger.log("request post query = " + querySb.toString());
    logger.log("request post headers = " + headers.toString());
    logger.log("request post body = " + body.toString());

    try {
      response = await post(querySb.toString(),
          headers: headers, body: json.encode(body));
    } catch (e) {
      logger.log("error post = " + e.toString());
      throw NotConnectedError();
    }

    logger.log("response post body = " + response.body.toString());
    logger.log("response post code = " + response.statusCode.toString());
    logger.log("response post headers = " + response.headers.toString());

    if (response.statusCode != 200) {
      throw RemoteServerError();
    }

    return response.body;
  }
}
