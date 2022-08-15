

import 'dart:io';

import 'package:video_player/video_player.dart';

class VideoManager{

 static final Map<String,VideoPlayerController> _controllerMap = {};

  static VideoPlayerController getVideoController(String url,{String? cacheId})  {
    if(cacheId != null && _controllerMap.containsKey(cacheId)){
      return _controllerMap[cacheId]!;
    }
    VideoPlayerController _videoPlayerController;
    if (url.startsWith('http')) {
      _videoPlayerController = VideoPlayerController.network(url);
    } else {
      final file = File(url);
      _videoPlayerController = VideoPlayerController.file(file);
    }
    // _videoPlayerController.initialize();
    if(cacheId != null){
      _controllerMap[cacheId] = _videoPlayerController;
    }
    return _videoPlayerController;
  }

 static removeChewieController(String? cacheId){
    if(cacheId != null) {
      _controllerMap.remove(cacheId);
    }
  }



}