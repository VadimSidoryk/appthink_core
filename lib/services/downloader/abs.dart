import 'dart:io';

import 'package:applithium_core/utils/extension.dart';
import 'package:async/async.dart';

enum DownloadStatus {
    running,
    failed,
    success
}

abstract class DownloaderService {

    static DownloaderService _mocked = _MockedDownloaderService();

    Stream<DownloadStatus> observeIsLoaded(String url);

    Future<Result<void>> download(String url);

    Future<Result<File>> open(String url);
}

class _MockedDownloaderService extends DownloaderService {
  @override
  Future<Result<void>> download(String url) => safeCall(() {});

  @override
  Stream<DownloadStatus> observeIsLoaded(String url) {
      return Stream.value(DownloadStatus.running);
  }

  @override
  Future<Result<File>> open(String url)  => safeCall(() {
      return File("");
  });
}



