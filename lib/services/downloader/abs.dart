import 'dart:io';

import 'package:appthink_core/utils/extension.dart';
import 'package:async/async.dart';

enum DownloadStatus {
    running,
    failed,
    success
}

abstract class DownloaderService {

    static DownloaderService mocked = _MockedDownloaderService();

    Stream<DownloadStatus> observeIsLoaded(String url);

    Future<Result<void>> download(String url);

    Future<Result<File>> open(String url);
}

class _MockedDownloaderService extends DownloaderService {
  @override
  Future<Result<void>> download(String url) => safeCall(this, () {});

  @override
  Stream<DownloadStatus> observeIsLoaded(String url) {
      return Stream.value(DownloadStatus.running);
  }

  @override
  Future<Result<File>> open(String url)  => safeCall(this, () {
      return File("");
  });
}



