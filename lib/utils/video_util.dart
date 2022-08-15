import 'dart:io';

import 'package:video_compress/video_compress.dart';
import 'package:wechat/core.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wechat/utils/file_utils.dart';

class VideoUtil{

  static Future<MediaInfo> videoMediaInfo(String path) async {
    return await VideoCompress.getMediaInfo(path);
  }

  static Future<MediaInfo?> compressVideo(String path) async {
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false, // It's false by default
    );
    return mediaInfo;
  }

  static  Future<File> videoThumbnail(String path) async {

    // var fileThumbnail = await VideoCompress.getFileThumbnail(path);
    var imageTemporaryDirectory = await FileUtils.getImageTemporaryDirectory();
    final thumbnail = await VideoThumbnail.thumbnailFile(
        video: path,
        thumbnailPath: imageTemporaryDirectory.path,
        maxHeight: 1280,
        maxWidth: 1280,
        quality: 100);
    return File(thumbnail!);
  }


}