import 'package:flutter_downloader/flutter_downloader.dart';

/// Represents information about a download task.
class TaskInfo {
  /// Constructs a new [TaskInfo] instance.
  TaskInfo({this.name, this.link, this.taskId, this.savedDir, this.progress, this.status});

  /// The name of the file being downloaded.
  final String? name;

  /// The URL of the file being downloaded.
  final String? link;

  /// The unique identifier of the download task.
  String? taskId;

  /// The directory where the downloaded file is saved.
  final String? savedDir;

  /// The progress of the download task, ranging from 0 to 100.
  int? progress = 0;

  /// The status of the download task.
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  /// Factory method to create TaskInfo objects from DownloadTask objects.
  factory TaskInfo.fromDownloadTask(DownloadTask downloadTask) {
    return TaskInfo(
      name: downloadTask.filename,
      link: downloadTask.url,
      taskId: downloadTask.taskId,
      progress: downloadTask.progress,
      status: downloadTask.status,
      savedDir:downloadTask.savedDir,
    );
  }
}
