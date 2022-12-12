import 'dart:io';

import 'package:async/async.dart';

abstract class DownloaderService {

    Stream<bool> observeIsLoaded(String url);

    Future<Result<void>> load(String url);

    Future<Result<File>> open(String url);
}