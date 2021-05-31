abstract class HttpClient {
  Future<dynamic> getImpl(String path, { Map<String, String> queryParams = const {}, Map<String, String> headers});

  Future<dynamic> postImpl(String path, Map<String, dynamic> body, {Map<String, String> headers});
}