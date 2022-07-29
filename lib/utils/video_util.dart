import 'package:wechat/core.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoUtil{

  static Future<MediaInfo?> compressVideo(String path) async {
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false, // It's false by default
    );
    return mediaInfo;
  }

  static  Future<String?>  videoThumbnail(String path) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
        video: path,
        thumbnailPath: null,
        maxHeight: 500.w.toInt(),
        maxWidth: 500.h.toInt(),
        quality: 10);
    return thumbnail;
  }

}