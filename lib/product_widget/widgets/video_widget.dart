import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import '../../../../../../core/managers/VideoManager.dart';
import '../../../../../../core/widgets/cached_net_work_image.dart';
import '../../../../../../core/widgets/play_button.dart';
import 'cover_widget.dart';

/// Widget class representing a product item with video or image attachment.
class VideoWidget extends StatefulWidget {
  final String imageUrl;
  final String videoUrl;
  final String accessKey;
  final double imageWidth;
  final double imageHeight;

  const VideoWidget({
    Key? key,
    required this.imageUrl,
    required this.videoUrl,
    required this.accessKey,
    required this.imageHeight,
    required this.imageWidth,
  }) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController? videoController = null;
  bool isInitialized = false;

  /// List of video URLs.
  List<String> videoUrls = [];

  /// Notifier for pause state.
  ValueNotifier<bool> isPaused = ValueNotifier<bool>(true);

  /// Notifier for loading state.
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
  }

  /// Initializes and plays the video.
  Future<void> _playVideos() async {
    isLoading.value = true;
    debugPrint('Video URL: ${widget.videoUrl}');
    debugPrint('Access Key: ${widget.accessKey}');

    videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      formatHint: VideoFormat.hls,
      httpHeaders: {
        'AccessKey': widget.accessKey,
        "Content-Type": "application/json",
      },
    );

    await videoController!.initialize();
    videoController!.addListener(_onVideoStateChanged);
    isInitialized = true;
    videoController!.seekTo(Duration.zero);
    VideoManager.playVideo(videoController!);
    isLoading.value = false;
  }

  /// Handles video state changes to update the pause state.
  Future<void> _onVideoStateChanged() async {
    await Future.delayed(const Duration(milliseconds: 300));
    isPaused.value = !videoController!.value.isPlaying;
  }

  @override
  void dispose() {
    if (videoController != null) {
      debugPrint('Disposing the video controller');
      isInitialized = false;
      VideoManager.stopAllVideos();
      VideoManager.disposeAllVideos();
      videoController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isPaused,
      builder: (BuildContext context, bool isPausedValue, Widget? child) {
        return isPausedValue
            ? ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (BuildContext context, bool isLoadingValue, Widget? child) {
            return _buildImageWithPlayButton(isLoading: isLoadingValue);
          },
        )
            : _buildVideoPlayer();
      },
    );
  }

  /// Builds the video player widget.
  Widget _buildVideoPlayer() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(
          aspectRatio: videoController!.value.aspectRatio,
          child: VideoPlayer(videoController!),
        ),
        VideoProgressIndicator(
          videoController!,
          allowScrubbing: true,
          colors: VideoProgressColors(
            playedColor: Theme.of(context).secondaryHeaderColor,
            bufferedColor: Theme.of(context).primaryColor.withOpacity(0.5),
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Builds the image with a play button overlay.
  Widget _buildImageWithPlayButton({required bool isLoading}) {
    return Stack(
      children: [
        CoverWidget(
          imageWidth: widget.imageWidth,
          imageHeight: widget.imageHeight,
          imageUrl: widget.imageUrl,
          accessKey: widget.accessKey,),
        PlayButton(
          onTap: _playVideos,
          isLoading: isLoading,
        ),
      ],
    );
  }

}
