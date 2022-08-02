import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/utils/image_util.dart';
import 'package:wechat/utils/navigator_utils.dart';
import '../../../../utils/video_util.dart';
import '../create_friend_circle_page.dart';

class CreateFriendCircleController extends BaseXController{

  final TextEditingController textEditingController = TextEditingController();

  VideoPlayerController? videoController;
  BMFPoiInfo? poiInfo;

  @override
  void onInit() {
    textEditingController.addListener(() {
      update();
    });
    super.onInit();
  }

  initVideo(File file) async {
    videoController?.dispose();
    videoController = VideoPlayerController.file(file);
    videoController?.addListener(() {
      if(videoController?.value.isInitialized??false){
        update();
      }
    });
    await videoController!.initialize();
  }

  createFriendCircle(int mediaType , List<File> files ){

    lcPost(() async {
      var lcObject = LCObject(Constant.OBJECT_NAME_FRIEND_CIRCLE);
      lcObject['mediaType'] = mediaType;

      if(mediaType == CreateFriendCirclePage.mediaTypeImage){
        List<Map<String,dynamic>> photos = [];
       await Future.forEach<File>(files, (element) async {
          var compressFile = await ImageUtil.compressImage(element);

          Map<String,dynamic> _info = {};

          if(compressFile != null){
            var _file = await LCFile.fromPath(element.filename, compressFile);
            await _file.save();
            var imageSize = await ImageUtil.imageSize(File(compressFile));
            _info['width'] = imageSize.width;
            _info['height'] = imageSize.height;
            _info['url'] =_file.url??'';
            photos.add(_info);
          }

        });
        lcObject['photos'] = photos;
      }else if(mediaType == CreateFriendCirclePage.mediaTypeVideo) {
        File video = files.first;
        debugPrint('video.path ${video.path} ${video.lengthSync()}');
        final thumbnailFile = await VideoUtil.videoThumbnail(video.path);
        debugPrint('thumbnailFile ${thumbnailFile.path}');
         var thumbnailLc = await LCFile.fromPath(thumbnailFile.filename, thumbnailFile.path);
         await thumbnailLc.save();

        var imageSize = await ImageUtil.imageSize(thumbnailFile);
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
      }
      lcObject['text'] = textEditingController.text.trim();
      lcObject['user'] = UserController.instance.user;
      if(poiInfo != null){
        lcObject['poiInfo'] = poiInfo?.toMap();
      }
      await lcObject.save();
      NavigatorUtils.pop(true);
    });

  }

  updatePoiInfo(BMFPoiInfo? poiInfo){
    this.poiInfo = poiInfo;
    update();
  }

  @override
  void onClose() {
    videoController?.dispose();
    super.onClose();
  }

}