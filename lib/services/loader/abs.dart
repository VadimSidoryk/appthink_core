import 'dart:io';

import 'package:async/async.dart';

abstract class LoaderService {
    Future<Result<void>> preload(String url);

    Future<Result<File>> open(String url);
}