import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:image_size_getter/image_size_getter.dart';
import '../../../../../../base/constant.dart';
import '../../../../../../controller/user_controller.dart';
import '../../../../../../utils/image_util.dart';
import '../../../../../../utils/navigator_utils.dart';
import '../../../../../../utils/video_util.dart';
import 'package:wechat/core.dart';
import 'package:video_compress/video_compress.dart';

class ChannelsCreateController extends BaseXController{

  final TextEditingController textEditingController = TextEditingController();
  BMFPoiInfo? poiInfo;
  File? videoFile;
  File? coverFile;
  Size? coverSize;

  @override
  void onInit() {
    videoFile = Get.arguments;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _buildGetVideoInfo(videoFile!);
  }

  deleteVideo(){
    videoFile = null;
    coverFile = null;
    coverSize = null;
    update();
  }

  selectVideo(File file){
    videoFile = file;
    _buildGetVideoInfo(file);
  }

  _buildGetVideoInfo(File videoFile){
    lcPost(() async {
      coverFile = await VideoUtil.videoThumbnail(videoFile.path);
      coverSize = await ImageUtil.imageSize(coverFile!);
      debugPrint('imageSize $coverSize');
    },showloading: false);
  }

  void updateCover(File cover) {
    coverFile = cover;
    update();
  }

  void updatePoiInfo(result) {
    poiInfo = result;
    update();
  }

  publishChannles() async {
    lcPost(() async {
      if(coverFile != null && videoFile != null){
        var lcObject = LCObject(Constant.OBJECT_NAME_CHANNLES);
        lcObject['user'] = UserController.instance.user;
        lcObject['video'] = {'url':videoFile?.path};

        File video = videoFile!;
        debugPrint('video.path ${video.path} ${video.lengthSync()}');
        var thumbnailLc = await LCFile.fromPath(coverFile!.filename, coverFile!.path);
        await thumbnailLc.save();

        var imageSize = await ImageUtil.imageSize(coverFile!);
        Map<String,dynamic> _thumbnailInfo = {};
        _thumbnailInfo['width'] = imageSize.width;
        _thumbnailInfo['height'] = imageSize.height;
        _thumbnailInfo['url'] =thumbnailLc.url??'';
        lcObject['thumbnail'] = _thumbnailInfo;
        MediaInfo? mediaInfo = await VideoUtil.compressVideo(video.path);
        debugPrint('mediaInfo ${mediaInfo?.width} ${mediaInfo?.height} ${mediaInfo?.orientation}');
        if(mediaInfo != null){
          var file = mediaInfo.file;
          var videoLc = await LCFile.fromPath(file!.filename, file.path);
          await videoLc.save();
          Map<String,dynamic> _videoInfo = {};
          _videoInfo['width'] = mediaInfo.height;
          _videoInfo['height'] = mediaInfo.width;
          _videoInfo['url'] =videoLc.url??'';
          lcObject['video'] = _videoInfo;
        }
        lcObject['text'] = textEditingController.text.trim();
        lcObject['user'] = UserController.instance.user;
        if(poiInfo != null){
          lcObject['poiInfo'] = poiInfo?.toMap();
        }
        await lcObject.save();
        NavigatorUtils.pop(true);
      }


    });
  }

}