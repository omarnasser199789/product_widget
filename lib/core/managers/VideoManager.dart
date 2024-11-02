import 'package:video_player/video_player.dart';

/// Class that manages video playback using the `video_player` package.
class VideoManager {

  /// The currently active video player controller.
  ///
  /// This controller is used to manage the playback of the currently active video.
  static late VideoPlayerController _activeController = VideoPlayerController.networkUrl(Uri.parse(""));

  /// Initializes the video playback with the specified controller.
  ///
  /// If the specified controller is different from the currently active controller,
  /// the currently active controller is paused and replaced with the new controller.
  static void initVideo(VideoPlayerController controller) {
    if (_activeController != controller) {
      _activeController.pause();
    }
    _activeController = controller;
  }

  /// Starts playing the video using the specified controller.
  ///
  /// If the specified controller is different from the currently active controller,
  /// the currently active controller is paused and replaced with the new controller.
  static void playVideo(VideoPlayerController controller) {
    if (_activeController != controller) {
      _activeController.pause();
    }
    _activeController = controller;
    _activeController.play();
  }

  /// Stops playback of all videos and disposes of their resources.
  ///
  /// This method pauses the currently active controller and replaces it with
  /// a new controller with an empty URL, effectively stopping all videos.
  static void stopAllVideos() {
    _activeController.pause();
    _activeController = VideoPlayerController.networkUrl(Uri.parse("")); // Empty URL stops all videos
  }

  /// Disposes of all video player resources.
  ///
  /// This method disposes of the currently active controller, releasing all
  /// resources associated with it.
  static void disposeAllVideos() {
    _activeController.dispose();
  }
}
