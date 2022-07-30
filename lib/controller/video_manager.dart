

import 'dart:io';

import 'package:video_player/video_player.dart';

class VideoManager{

 static final Map<String,VideoPlayerController> _controllerMap = {};

  static VideoPlayerController getVideoController(String url)  {
    if(_controllerMap.containsKey(url)){
      return _controllerMap[url]!;
    }
    VideoPlayerController _videoPlayerController;
    if (url.startsWith('http')) {
      _videoPlayerController = VideoPlayerController.network(url);
    } else {
      final file = File(url);
      _videoPlayerController = VideoPlayerController.file(file);
    }
    _videoPlayerController.initialize();
    _controllerMap[url] = _videoPlayerController;
    return _videoPlayerController;
  }

 static removeChewieController(String url){
    _controllerMap.remove(url);
  }



}