import 'dart:io';

import 'package:async/async.dart';

abstract class DownloaderService {

    Stream<DownloadStatus> observeIsLoaded(String url);

    Future<Result<void>> download(String url);

    Future<Result<File>> open(String url);
}

enum DownloadStatus {
    running,
    failed,
    success
}