import 'dart:io';

import 'package:video_compress/video_compress.dart';

class VideoUtil{

  static Future<MediaInfo?> compressVideo(String path) async {
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false, // It's false by default
    );
    return mediaInfo;
  }

  static  Future<File> videoThumbnail(String path) async {
    var fileThumbnail = await VideoCompress.getFileThumbnail(path);
    // final thumbnail = await VideoThumbnail.thumbnailFile(
    //     video: path,
    //     thumbnailPath: null,
    //     maxHeight: 500.w.toInt(),
    //     maxWidth: 500.h.toInt(),
    //     quality: 10);
    return fileThumbnail;
  }


}