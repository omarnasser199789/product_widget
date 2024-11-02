import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:path/path.dart';
import 'package:random_string/random_string.dart';
import 'task_info.dart';

CachingManager cachingManager = CachingManager();

/// Manages the caching of videos using the `flutter_downloader` package.
class CachingManager {
  final ReceivePort _port = ReceivePort();
  List<TaskInfo>? _tasks;

  /// Initializes a new instance of the `CachingManager` class.
  ///
  /// Calls the [initVideoCachingManager] method to initialize the video caching manager.
  CachingManager(){
    initVideoCachingManager();
  }

  /// Initializes the video caching manager.
  ///
  /// Binds the background isolate and registers the download callback
  /// for handling download progress updates.
  void initVideoCachingManager() {
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback, step: 5);
  }

  /// Disposes of the resources used by the caching manager.
  ///
  /// Unbinds the background isolate to release resources.
  void dispose() {
    _unbindBackgroundIsolate();
  }

  /// Callback function called from the background isolate for download progress updates.
  ///
  /// Receives download progress updates from the background isolate and sends
  /// them to the main isolate for processing.
  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    debugPrint('Callback on background isolate: task ($id) is in status ($status) and process ($progress)');
    // if (status == DownloadTaskStatus.undefined) {
    //   debugPrint("Undefined");
    // } else if (status == DownloadTaskStatus.running) {
    //   debugPrint("Running");
    // } else if (status == DownloadTaskStatus.paused) {
    //   debugPrint("Paused");
    // } else if (status == DownloadTaskStatus.complete || status == DownloadTaskStatus.canceled) {
    //   debugPrint("Complete || Canceled");
    // } else if (status == DownloadTaskStatus.failed) {
    //   debugPrint("Failed");
    // }

    IsolateNameServer.lookupPortByName('downloader_send_port')?.send([id, status, progress]);
  }

  /// Downloads a file from the provided URL.
  ///
  /// If the file is already downloaded, returns the existing [TaskInfo].
  /// Otherwise, enqueues a new download and returns a [TaskInfo] for the download task.
  Future<TaskInfo?> downloadFile(String fileUrl) async {
    Completer<TaskInfo?> completer = Completer<TaskInfo?>();

    TaskInfo? taskInfo = await isFileDownloaded(fileUrl);

    if (taskInfo != null) {
      // File is already downloaded, return the existing task info
      completer.complete(taskInfo);
    } else {
      // File is not downloaded, enqueue a new download
      String savedDir = await _findTemporaryLocalPath();

      FlutterDownloader.enqueue(
        url: fileUrl,
        savedDir: savedDir,
        fileName: _getFileNameFromUrl(fileUrl),
        showNotification: true,
        openFileFromNotification: true,
      ).then((taskId) {
        completer.complete(TaskInfo(
          name: _getFileNameFromUrl(fileUrl),
          taskId: taskId,
          savedDir: savedDir,
        ));
      }).catchError((error) {
        completer.completeError(error); // Handle errors if necessary
      });
    }

    return completer.future;
  }

  /// Downloads multiple files concurrently.
  ///
  /// Uses `Future.wait()` to download all files concurrently and waits for all tasks to complete.
  Future<void> downloadFiles(List<String> fileUrls) async {
    // Use Future.wait() to download all files concurrently and wait for all tasks to complete
    await Future.wait(fileUrls.map((fileUrl) async {
      String savedDir = await _findTemporaryLocalPath();

      for (String fileUrl in fileUrls) {
        await FlutterDownloader.enqueue(
          url: fileUrl,
          savedDir: savedDir,
          showNotification: true,
          openFileFromNotification: true,
        );
      }
    }));

  }

  /// Pauses the download of a specific task.
  ///
  /// Pauses the download task with the specified task ID.
  Future<void> pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  /// Pauses all ongoing download tasks.
  ///
  /// Pauses all download tasks that are currently running.
  Future<void> pauseAllTasks() async {
    List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();

    if (tasks != null && tasks.isNotEmpty) {
      for (DownloadTask task in tasks) {
        // if (task.status == DownloadTaskStatus.running) {
          await FlutterDownloader.pause(taskId: task.taskId);
        // }
      }
    }
  }

  /// Cancels all enqueued, running, or paused download tasks.
  ///
  /// Cancels all download tasks that are enqueued, running, or paused.
  Future<void> cancelAllTasks() async {
    List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();

    if (tasks != null && tasks.isNotEmpty) {
      for (DownloadTask task in tasks) {
        if (task.status == DownloadTaskStatus.enqueued ||
            task.status == DownloadTaskStatus.running ||
            task.status == DownloadTaskStatus.paused
        ) {
          await FlutterDownloader.cancel(taskId: task.taskId);
        }
      }
    }
  }

  /// Resumes all paused download tasks.
  ///
  /// Resumes all download tasks that are currently paused and have progress greater than 0.
  Future<void> resumeAllTasks() async {
    List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();

    if (tasks != null && tasks.isNotEmpty) {
      for (DownloadTask task in tasks) {
        if (task.status == DownloadTaskStatus.paused) {
          if(task.progress>0){
            String? msg = await FlutterDownloader.resume(taskId: task.taskId);
            debugPrint(msg);
          }
        }
      }
    }
  }

  /// Retries a failed download task.
  ///
  /// Retries the download task with the specified task ID if it has failed.
  Future<void> retryDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  /// Opens the downloaded file associated with a specific task.
  ///
  /// Opens the downloaded file associated with the specified task ID.
  /// Returns true if the file is successfully opened, false otherwise.
  Future<bool> openDownloadedFile(TaskInfo? task) async {
    final taskId = task?.taskId;

    if (taskId == null) {
      return false;
    }

    return FlutterDownloader.open(taskId: taskId);
  }

  /// Deletes a downloaded file and its associated task.
  ///
  /// Deletes the downloaded file and its associated task with the specified task ID.
  Future<void> delete(TaskInfo task) async {
    await FlutterDownloader.remove(
      taskId: task.taskId!,
      shouldDeleteContent: true,
    );
  }

  /// Checks if a file with the given URL has been downloaded.
  ///
  /// Checks if a file with the specified URL has been downloaded by
  /// searching through the list of downloaded tasks.
  /// Returns a [TaskInfo] object if the file is downloaded, or null if it is not.
  Future<TaskInfo?> isFileDownloaded(String fileUrl) async {
    Completer<TaskInfo?> completer = Completer<TaskInfo?>();

    loadTasks().then((List<TaskInfo> tasks) {
      for (TaskInfo task in tasks) {
        if (task.link == fileUrl && task.status == DownloadTaskStatus.complete) {
          completer.complete(task); // The file is already downloaded
          return;
        }
      }
      completer.complete(null); // The file is not downloaded
    }).catchError((error) {
      completer.completeError(error); // Handle errors if necessary
    });

    return completer.future;
  }

  /// Gets a list of paused download tasks.
  ///
  /// Retrieves a list of paused download tasks by iterating through
  /// all tasks and adding those with a status of paused to the result list.
  /// Returns a list of [TaskInfo] objects representing paused download tasks.
  Future<List<TaskInfo>> getPausedTasks() async {
    List<TaskInfo> pausedTasks = [];

    List<TaskInfo> tasks = await loadTasks();

    for (TaskInfo task in tasks) {
      if (task.status == DownloadTaskStatus.paused) {
        pausedTasks.add(task);
      }
    }

    return pausedTasks;
  }

  /// Loads all download tasks.
  ///
  /// Retrieves a list of all download tasks using FlutterDownloader's
  /// `loadTasks` method. Maps the retrieved list of DownloadTask objects
  /// to a list of TaskInfo objects using the `fromDownloadTask` constructor.
  /// Returns a list of [TaskInfo] objects representing all download tasks.
  Future<List<TaskInfo>> loadTasks() async {
    List<TaskInfo> taskInfoList=[];
    List<DownloadTask>? downloadTasks = await FlutterDownloader.loadTasks();
    if(downloadTasks!=null){
      taskInfoList = downloadTasks.map((task) => TaskInfo.fromDownloadTask(task)).toList();
    }

    return taskInfoList;
  }

  /// Finds the local path where downloaded files are stored.
  ///
  /// Retrieves the documents directory using the `getApplicationDocumentsDirectory`
  /// method from the `path_provider` package. Returns a [String] representing
  /// the path to the documents directory.
  Future<String> _findLocalPath() async {
    // Get the documents directory
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }


  /// Finds the local path where temporary files are stored.
  ///
  /// Retrieves the temporary directory using the `getTemporaryDirectory`
  /// method from the `path_provider` package. Returns a [String] representing
  /// the path to the temporary directory.
  Future<String> _findTemporaryLocalPath() async {
    // Get the temporary directory
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  /// Generates a random file name for the downloaded file.
  ///
  /// Generates a random alphanumeric string of length 8 using the
  /// `randomAlphaNumeric` method from the `random_string` package. This
  /// string is appended to the base name of the file extracted from the
  /// provided [fileUrl] using the `basename` method from the `path` package.
  ///
  /// Returns a [String] representing the generated file name.
  String _getFileNameFromUrl(String fileUrl) {
    // Generate a random string to append to the output file name
    String randomString = randomAlphaNumeric(8); // Change the length as needed

    // Extract the file name from the URL using the basename method from the path package
    return "${randomString}${basename(fileUrl)}";
  }

  /// Binds the background isolate to the main isolate.
  ///
  /// Registers the `_port.sendPort` with the name 'downloader_send_port' using
  /// `IsolateNameServer.registerPortWithName`. If the registration is successful,
  /// listens for messages on the `_port` and updates the status and progress of
  /// the corresponding download task.
  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;

      debugPrint('Callback on UI isolate: task ($taskId) is in status ($status) and process ($progress)');

      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == taskId);
        task
          ..status = status
          ..progress = progress;

      }
    });
  }

  /// Unbinds the background isolate from the main isolate.
  ///
  /// Removes the port name mapping for 'downloader_send_port' using
  /// `IsolateNameServer.removePortNameMapping`.
  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
}
