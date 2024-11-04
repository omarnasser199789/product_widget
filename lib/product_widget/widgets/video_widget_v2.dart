import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:io';
import '../../../../../../core/managers/VideoManager.dart';
import '../../../../../../core/managers/video_caching_manager.dart';
import '../../../../../../core/managers/video_urls_manager.dart';
import '../../../../../../core/widgets/cached_net_work_image.dart';
import '../../../../../../core/widgets/play_button.dart';
/// Widget class representing a product item with video or image attachment
class VideoWidgetV2 extends StatefulWidget {
  final String imageUrl;
  final String videoUrl;
  final String accessKey;
  final double imageWidth;
  final double imageHeight;

  const VideoWidgetV2({
    Key? key,
    required this.imageUrl,
    required this.videoUrl,
    required this.accessKey,
    required this.imageHeight,
    required this.imageWidth,
  }) : super(key: key);

  @override
  State<VideoWidgetV2> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<VideoWidgetV2> {
  late VideoPlayerController? videoController = null;
  List<String> videoUrls = [];
  bool isInitialized =false;
  /// Notifier for pause state
  ValueNotifier<bool>  isPaused = ValueNotifier<bool>(true);
  ValueNotifier<bool>  isLoading = ValueNotifier<bool>(false);
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();
  }


  // Future<void> _downloadAndCacheVideos() async {
  //   print("Start download and cache video");
  //   isLoading.value = true;
  //
  //   int maxRetries = 3; // Maximum number of retry attempts
  //   int retryCount = 0;
  //   bool success = false;
  //
  //   while (retryCount < maxRetries && !success) {
  //     try {
  //       String p360AsMp4Url = VideoUrlManager.generateVideoUrl(VideoQuality.p360AsMp4, widget.videoUrl);
  //       String? fileDir = await videoCachingManager.checkIfFileExists(p360AsMp4Url);
  //       if(fileDir!=null){
  //         print("Play video from file*****");
  //         File file = File(fileDir);
  //         videoController = VideoPlayerController.file(file);
  //       }else{
  //         print("Play video from URL^^^^^^");
  //         videoCachingManager.stopCaching();
  //         String p180Url = VideoUrlManager.generateVideoUrl(VideoQuality.p180, widget.videoUrl);
  //         print(p180Url);
  //         videoController = VideoPlayerController.networkUrl(Uri.parse(p180Url),formatHint: VideoFormat.hls,);
  //       }
  //
  //       await videoController!.initialize();
  //       videoController!.addListener(_onVideoStateChanged);
  //       isInitialized = true;
  //       videoController!.seekTo(Duration.zero);
  //       VideoManager.playVideo(videoController!);
  //       success = true; // Set success to true if the operation is successful
  //     } catch (error) {
  //       print("Error downloading or initializing video: $error");
  //       retryCount++;
  //       if (retryCount < maxRetries) {
  //         print("Retrying... Attempt $retryCount");
  //       } else {
  //         print("Max retry attempts reached. Unable to download video.");
  //         // Handle the error or show a message to the user indicating that retries have failed.
  //       }
  //     }
  //   }
  //
  //   isLoading.value = false;
  // }

  /// Handle video state changes
  Future<void> _onVideoStateChanged() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Check if the video is paused
    isPaused.value = videoController!.value.isPlaying ? false : true;

    _isBuffering = videoController!.value.isBuffering;
    debugPrint("_isBuffering:$_isBuffering");

    if (_isBuffering) {
      videoCachingManager.stopCaching();
    } else {
      videoCachingManager.resumeCaching();
    }
  }

  @override
  void dispose() {
    if(videoController!=null){
      debugPrint('Start Dispose the video');
      isInitialized = false;
      VideoManager.stopAllVideos();
      VideoManager.disposeAllVideos();
      videoController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isPaused,
      builder: (BuildContext context, bool isPausedValue, Widget? child) {
        if(isPausedValue){
          return ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (BuildContext context, bool isLoadingValue, Widget? child) {
              return Stack(
                children: [
                  _buildImageWithPlayButton(),
                  if(isLoadingValue)
                    const Padding(
                      padding: EdgeInsets.all(9.3),
                      child: CircularProgressIndicator(color: Colors.red,),
                    ),
                ],
              );
            },
          );

        }else{
          return _buildVideoPlayer();
        }
      },
    );
  }

  /// Widget for displaying product image or video with play button
  Widget _buildVideoPlayer() {
    return  Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(
          aspectRatio: videoController!.value.aspectRatio,
          child: VideoPlayer(videoController!),
        ),
        VideoProgressIndicator(videoController!, allowScrubbing: true,
          colors: VideoProgressColors(
              playedColor:Theme.of(context).secondaryHeaderColor,
              bufferedColor:Theme.of(context).primaryColor.withOpacity(0.5),
              backgroundColor:Colors.white
          ),
        )
      ],
    );
  }

  /// Widget for displaying image with play button overlay
  Widget _buildImageWithPlayButton() {
    return Stack(
      children: [
        _buildCachedNetworkImage(),
        PlayButton(onTap: (){
          // _downloadAndCacheVideos();
        }),
      ],
    );
  }

  /// Widget for displaying cached network image
  Widget _buildCachedNetworkImage() {
    return AspectRatio(
      aspectRatio: 1,//widget.imageWidth/widget.imageHeight,
      child: CachedNetWorkImage(
        url: widget.imageUrl,
        accessKey: widget.accessKey,
        // imageWidth: widget.imageWidth,
        // imageHeight: widget.imageHeight,
      ),
    );
  }

}
