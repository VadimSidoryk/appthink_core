import 'dart:io';

import 'package:applithium_core/services/downloader/abs.dart';
import 'package:applithium_core/utils/extension.dart';
import 'package:async/src/result/result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:rxdart/subjects.dart';

class DownloaderServiceImpl extends DownloaderService {
  static final _nameFolder = "downloads";

  final Map<String, String> _urlToTaskId = {};
  final Map<String, String> _taskIdToUrl = {};
  final Map<String, BehaviorSubject<DownloadTaskStatus>> _urlToStatus = {};

  DownloaderServiceImpl() {
    _init();
  }

  Future<Result<void>> _init() => safeCall(() async {
        await FlutterDownloader.initialize(
            debug: kDebugMode,
            // optional: set to false to disable printing logs to console (default: true)
            ignoreSsl:
                true // option: set to false to disable working with http links (default: false)
            );

        final List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();
        if (tasks?.isNotEmpty == true) {
          for (DownloadTask task in tasks!) {
            _addTask(task.taskId, task.url, task.status);
          }
        }

        FlutterDownloader.registerCallback(
            (id, DownloadTaskStatus status, progress) {
          _changeStatusById(id, status);
        });
      });

  @override
  Stream<DownloadStatus> observeIsLoaded(String url) {
    if (_urlToStatus.containsKey(url)) {
      return _urlToStatus[url]!
          .map(_mapInternalStatus);
    } else {
      _urlToStatus[url] = BehaviorSubject<DownloadTaskStatus>();
      return _urlToStatus[url]!
          .map(_mapInternalStatus);
    }
  }

  @override
  Future<Result<File>> open(String url) => safeCall(() async {
        if (!_urlToStatus.containsKey(url)) {
          await download(url);
        }

        await _urlToStatus[url]!
            .firstWhere((element) => element == DownloadTaskStatus.complete);
        return File("$_nameFolder/${url.split('/').last}");
      });

  @override
  Future<Result<void>> download(String url) => safeCall(() async {
        final taskId = await FlutterDownloader.enqueue(
          url: url,
          headers: {},
          // optional: header send with url (auth token etc)
          savedDir: _nameFolder,
          showNotification: false,
          // show download progress in status bar (for Android)
          openFileFromNotification:
              false, // click on notification to open downloaded file (for Android)
        );

        if (taskId != null) {
          _addTask(taskId, url, DownloadTaskStatus.undefined);
        }
      });

  DownloadStatus _mapInternalStatus(DownloadTaskStatus status) {
    if(status == DownloadTaskStatus.complete) {
      return DownloadStatus.success;
    } else if(status == DownloadTaskStatus.failed || status == DownloadTaskStatus.canceled) {
      return DownloadStatus.failed;
    } else {
      return DownloadStatus.running;
    }
  }
  _addTask(String taskId, String url, DownloadTaskStatus status) {
    if (!_taskIdToUrl.containsKey(taskId)) {
      _taskIdToUrl[taskId] = url;
      _urlToTaskId[url] = taskId;
    }

    if (_urlToStatus.containsKey(url)) {
      _urlToStatus[url]?.add(status);
    } else {
      _urlToStatus[url] = BehaviorSubject.seeded(status);
    }
  }

  _changeStatusById(String taskId, DownloadTaskStatus status) {
    if (_taskIdToUrl.containsKey(taskId)) {
      final url = _taskIdToUrl[taskId]!;
      _urlToStatus[url]?.add(status);
    }
  }
}
