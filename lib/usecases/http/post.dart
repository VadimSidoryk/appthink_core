import 'package:applithium_core/networking/errors.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:http/http.dart';

class HttpPostUseCase<T> extends UseCase<T> {

  final Uri uri;
  final Map<String, String> headers;

  HttpPostUseCase(this.uri, { this.headers = const {}}) {
    this.headers..['content-type'] = 'application/json';
  }

  @override
  Stream<T> invokeImpl({T? state}) async* {
    state as T;
    final response;
    try {
      response = await post(uri, body: state, headers: headers);
    } catch (e) {
      throw NotConnectedError(uri, DateTime.now().millisecondsSinceEpoch);
    }

    if (response.statusCode != 200) {
      throw RemoteServerError(uri, response.statusCode, response.bodyJson);
    }
    yield state;
  }

}