abstract class HttpClient {
  Future<dynamic> getImpl(String path, { String query = "", Map<String, String> headers});

  Future<dynamic> postImpl(String path, Map<String, dynamic> body, {Map<String, String> headers});
}