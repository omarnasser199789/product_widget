//
// /// Enum representing different video quality options.
// ///
// /// Each enum value corresponds to a specific video quality and its associated
// /// file extension. The `auto` quality is used when the video player should
// /// automatically select the appropriate quality based on the user's network
// /// conditions.
// enum VideoQuality {
//   auto,
//   p180,
//   p270,
//   p360,
//   p360AsMp4,
//   p540,
//   p720,
//   p1080,
// }
//
// /// Static class that maps each `VideoQuality` enum value to its corresponding
// /// file extension for generating video URLs.
// class VideoQualityValues {
//   static const Map<VideoQuality, String> values = {
//     VideoQuality.auto: 'index.m3u8',
//     VideoQuality.p180: '180p.m3u8',
//     VideoQuality.p270: '270p.m3u8',
//     VideoQuality.p360: '360p.m3u8',
//     VideoQuality.p360AsMp4: '360p.mp4',
//     VideoQuality.p540: '540p.m3u8',
//     VideoQuality.p720: '720p.m3u8',
//     VideoQuality.p1080: '1080p.m3u8',
//   };
// }
//
// /// Exception thrown when an invalid URL is provided.
// class InvalidUrlException implements Exception {
//   String errorMessage() => 'Invalid URL provided.';
// }
//
// /// Exception thrown when an invalid video quality is selected.
// class InvalidVideoQualityException implements Exception {
//   String errorMessage() => 'Invalid video quality selected.';
// }
//
// /// Class that manages the generation of video URLs based on quality and base URL.
// class VideoUrlManager {
//
//   /// Generates a video URL based on the selected quality and base URL.
//   ///
//   /// Throws an [InvalidUrlException] if the base URL does not contain '/index.m3u8'.
//   /// Throws an [InvalidVideoQualityException] if the selected quality is not valid.
//   static String generateVideoUrl(VideoQuality quality, String baseUrl) {
//     if (!baseUrl.contains('/index.m3u8')) {
//       throw InvalidUrlException();
//     }
//
//     String? qualityString = VideoQualityValues.values[quality];
//     if (qualityString == null) {
//       throw InvalidVideoQualityException();
//     }
//
//     String baseUrlWithoutExtension = baseUrl.replaceAll('/index.m3u8', ''); // Remove index.m3u8 from the URL
//     return '$baseUrlWithoutExtension/$qualityString';
//   }
// }
//
// void main() {
//   String inputUrl = 'https://hi-erbil.s3.amazonaws.com/processVideos/2023/November/1698839730516_ywOTZOFiLu/index.m3u8';
//
//   try {
//     VideoQuality selectedQuality = VideoQuality.auto;
//     String videoUrl = VideoUrlManager.generateVideoUrl(selectedQuality, inputUrl);
//
//     // Output the generated video URL
//     print(videoUrl);
//   } catch (e) {
//     print('Error: $e');
//   }
// }
