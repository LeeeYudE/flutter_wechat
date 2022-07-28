import 'dart:io';

import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:video_compress/video_compress.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/utils/luban_util.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../create_friend_circle_page.dart';

class CreateFriendCircleController extends BaseXController{

  final TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    textEditingController.addListener(() {
      update();
    });
    super.onInit();
  }

  createFriendCircle(int mediaType , List<File> files ){

    lcPost(() async {
      var lcObject = LCObject(Constant.OBJECT_NAME_FRIEND_CIRCLE);
      lcObject['mediaType'] = mediaType;

      if(mediaType == CreateFriendCirclePage.mediaTypeImage){
        List<String> photos = [];
       await Future.forEach<File>(files, (element) async {
          var compressFile = await LubanUtil.compress(element);
          if(compressFile != null){
            var _file = await LCFile.fromPath(element.filename, compressFile);
            await _file.save();
            photos.add(_file.url??'');
          }

        });
        lcObject['photos'] = photos;
      }else if(mediaType == CreateFriendCirclePage.mediaTypeVideo) {
        File video = files.first;
        final thumbnail = await VideoThumbnail.thumbnailFile(
            video: video.path,
            thumbnailPath: null,
            maxHeight: 500.w.toInt(),
            maxWidth: 500.h.toInt(),
            quality: 10);
        if(thumbnail != null){
          var thumbnailFile = File(thumbnail);
           var thumbnailLc = await LCFile.fromPath(thumbnailFile.filename, thumbnailFile.path);
           await thumbnailLc.save();
          lcObject['thumbnail'] = thumbnailLc.url;
          MediaInfo? mediaInfo = await VideoCompress.compressVideo(
            video.path,
            quality: VideoQuality.DefaultQuality,
            deleteOrigin: false, // It's false by default
          );
          if(mediaInfo != null){
            var file = mediaInfo.file;
            var videoLc = await LCFile.fromPath(file!.filename, file!.path);
            await videoLc.save();
            lcObject['video'] = videoLc;
          }
        }
      }
      lcObject['text'] = textEditingController.text.trim();
      lcObject['user'] = UserController.instance.user;
      lcObject.save();
      NavigatorUtils.pop(true);

    });

  }

}