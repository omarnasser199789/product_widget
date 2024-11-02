import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:collection';
import 'caching_manager/caching_manager.dart';
import 'caching_manager/task_info.dart';

/// Instance of VideoCachingManager to manage video caching operations
VideoCachingManager videoCachingManager = VideoCachingManager();

/// Class to manage video caching functionalities
class VideoCachingManager {
  /// Queue to store video URLs for caching
  Queue<String> videoUrlQueue = Queue<String>();

  /// Flag to control whether the caching process should continue
  bool _shouldContinueCaching = true;

  /// Enqueues a video URL into the caching queue.
  ///
  /// This method adds the specified video URL to the end of the queue,
  /// preparing it for future caching operations. The queue follows a
  /// First-In-First-Out (FIFO) order, which means videos added first are
  /// cached first.
  ///
  /// [url] is a String containing the URL of the video to be cached.
  /// It should be a valid URL pointing to the video resource that needs
  /// to be downloaded and cached.
  ///
  /// This method does not return a value as it merely modifies the state
  /// of the queue by adding a new element.
  void enqueue(String url) {
    videoUrlQueue.add(url);
  }

  /// Dequeues the first video URL from the caching queue.
  ///
  /// This method removes and returns the first URL from the queue if the queue
  /// is not empty, following the First-In-First-Out (FIFO) order established
  /// during the enqueuing process. This method is typically called to retrieve
  /// the next video URL for caching.
  ///
  /// This method does not take any parameters.
  ///
  /// Returns a String containing the URL that was at the front of the queue,
  /// allowing it to be processed for caching. If the queue is empty, it returns
  /// null, indicating that there are no more videos to cache at the moment.
  ///
  /// Return type:
  ///   - `String?`: Nullable string that will either be a valid URL or null
  ///     if the queue is empty.
  String? dequeue() {
    if (videoUrlQueue.isNotEmpty) {
      return videoUrlQueue.removeFirst();
    }
    return null;
  }

  /// Removes a specific URL from the caching queue.
  ///
  /// This method searches the queue for all instances of the specified URL and
  /// removes them. It is used to manage the queue by selectively deleting entries
  /// that no longer need to be cached, perhaps due to a cancellation request or
  /// an error in the initial addition. This ensures that the queue remains
  /// up-to-date with only relevant URLs to be processed.
  ///
  /// [url] is a String parameter that specifies the video URL to be removed from
  /// the queue. It should match exactly the URL that was previously enqueued.
  ///
  /// This method does not return a value; it modifies the state of the queue by
  /// removing elements that match the provided URL.
  void removeUrlFromQueue(String url) {
    videoUrlQueue.removeWhere((element) => element == url);
  }

  /// Stops the video caching process.
  ///
  /// This method pauses all ongoing caching tasks and sets the internal flag
  /// `_shouldContinueCaching` to false. This flag controls the caching loop in
  /// [cacheVideos], ensuring that no new videos are added to the caching queue
  /// and the current caching operation is stopped gracefully.
  ///
  /// This method does not take any parameters.
  void stopCaching() {
    debugPrint("Set the flag to stop caching");
    cachingManager.pauseAllTasks();
    _shouldContinueCaching = false; // Set the flag to stop caching
  }

  /// Resumes the video caching process after a delay.
  ///
  /// This method delays the resumption of caching by 1000 milliseconds (1 second)
  /// to allow for any necessary preparation or setup. After the delay, it sets
  /// the internal flag `_shouldContinueCaching` to true, indicating that caching
  /// should resume. It then immediately starts caching videos by calling
  /// [cacheVideos] with an empty list, which triggers the caching process if
  /// there are videos in the queue.
  ///
  /// This method does not take any parameters.
  Future<void> resumeCaching() async {
     await Future.delayed(const Duration(milliseconds: 1000));
     debugPrint("Set the flag to resume caching");
    _shouldContinueCaching = true; // Set the flag to resume caching
    cacheVideos([]); // Start caching immediately when resumed
  }

  /// Checks if a cached video file exists for a given URL.
  ///
  /// This method uses the [cachingManager] to check if a file has been
  /// downloaded for the specified video URL. If a file is found and its
  /// download status is complete, the method returns the full path to the
  /// downloaded file. If no file is found or the download status is not
  /// complete, it returns null.
  ///
  /// [videoUrl] is a String containing the URL of the video to check for
  /// cached file existence.
  ///
  /// Returns a String representing the full path to the cached file if it
  /// exists and is complete, or null if no file is found or it is not
  /// complete.
  Future<String?> checkIfFileExists(String videoUrl) async {
    try {
      TaskInfo? taskInfo = await cachingManager.isFileDownloaded(videoUrl);
      if(taskInfo!=Null){
        if(taskInfo!.status == DownloadTaskStatus.complete ){
          return "${taskInfo.savedDir}/${taskInfo.name}";
        }
       return null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Caches videos from the provided list of URLs.
  ///
  /// This method resumes all caching tasks, adds the video URLs from the
  /// provided list to the caching queue, and starts caching videos in a
  /// First-In-First-Out (FIFO) manner until the queue is empty or caching
  /// is interrupted. Caching is interrupted if the `_shouldContinueCaching`
  /// flag is set to false.
  ///
  /// [videoUrls] is a List of Strings containing the URLs of the videos to
  /// be cached.
  ///
  /// This method does not return a value; it logs a message to indicate
  /// that caching has been completed for all videos.
  Future<void> cacheVideos(List<String> videoUrls) async {

    await cachingManager.resumeAllTasks();

    // Add video URLs to the queue
    videoUrls.forEach((url) => enqueue(url));

    // Cache videos in a FIFO manner
    while (videoUrlQueue.isNotEmpty && _shouldContinueCaching) {
      String? url = dequeue();
      if (url != null) {
        await _cacheVideo(url);
      }
    }
    debugPrint('Caching completed for all videos.');
  }

  /// Caches a video from the specified URL.
  ///
  /// This method attempts to cache a video from the specified URL. It allows
  /// for a maximum of three retry attempts in case of caching failure. If the
  /// caching is successful, it sets the `success` flag to true and logs a
  /// success message. If the maximum number of retries is reached without
  /// success, it logs a failure message.
  ///
  /// [url] is a String containing the URL of the video to be cached.
  ///
  /// This method does not return a value; it logs messages to indicate
  /// the caching status.
  Future<void> _cacheVideo(String url) async {
    debugPrint("Start caching: $url");
    int maxRetries = 3; // Maximum number of retry attempts
    int retryCount = 0;
    bool success = false;

    while (retryCount < maxRetries && !success) {
      try {
        // debugPrint('Caching video: $url');
        await cachingManager.downloadFile(url);
        debugPrint('Video cached successfully: $url');
        success = true; // Set success to true if caching is successful
      } catch (e) {
        debugPrint('Error caching video: $url');
        debugPrint(e.toString());
        retryCount++;
        if (retryCount < maxRetries) {
          debugPrint('Retrying... Attempt $retryCount');
        } else {
          debugPrint('Max retry attempts reached. Unable to cache video: $url');
          // Handle the error or show a message to the user indicating that retries have failed.
        }
      }
    }
  }
}
