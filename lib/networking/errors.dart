class NotConnectedError implements Exception {
  final Uri uri;
  final int timeMillis;

  NotConnectedError(this.uri, this.timeMillis);
}

class RemoteServerError implements Exception {
  final Uri uri;
  final int code;
  final String error;

  RemoteServerError(this.uri, this.code, this.error);
}
