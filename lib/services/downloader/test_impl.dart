import 'dart:io';

import 'package:appthink_core/services/downloader/abs.dart';
import 'package:appthink_core/utils/extension.dart';
import 'package:async/src/result/result.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class TestDownloaderService extends DownloaderService {
  final _httpClient = new HttpClient();
  final Map<String, BehaviorSubject<DownloadStatus>> _urlToStatus = {};

  @override
  Future<Result<void>> download(String url) => safeCall(this, () async {
    final isExist = await _checkIfExist(url);
        if(isExist) {
          return;
        }

        if (_urlToStatus.containsKey(url)) {
          return;
        }

        _urlToStatus[url] = BehaviorSubject.seeded(DownloadStatus.running);
        var request = await _httpClient.getUrl(Uri.parse(url));
        var response = await request.close();
        var bytes = await consolidateHttpClientResponseBytes(response);
        final path = await _getFilePath(url);
        File file = new File(path);
        await file.writeAsBytes(bytes);
      });

  @override
  Stream<DownloadStatus> observeIsLoaded(String url) async* {
    final isExist = await _checkIfExist(url);
    if (isExist) {
      yield DownloadStatus.success;
    } else if (_urlToStatus.containsKey(url)) {
      yield* _urlToStatus[url]!;
    } else {
      yield DownloadStatus.failed;
    }
  }

  @override
  Future<Result<File>> open(String url) => safeCall(this, () async {
        if (_urlToStatus.containsKey(url)) {
          //download in progress
          await _urlToStatus[url]!
              .firstWhere((element) => element == DownloadStatus.success);
        } else {
          await download(url);
        }
        final filePath = await _getFilePath(url);
        return File(filePath);
      });

  Future<String> _getFilePath(String url) async {
    final uri = Uri.parse(url);
    final fileName = uri.path.split("/").last.replaceAll("%2F", "_");
    String dir = (await getTemporaryDirectory()).path;
    return '$dir/$fileName';
  }

  Future<bool> _checkIfExist(String url) async {
    final path = await _getFilePath(url);
    return await File(path).exists();
  }
}
