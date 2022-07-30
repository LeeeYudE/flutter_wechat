import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat/controller/video_manager.dart';

import '../core.dart';

class VidwoPlayWidget extends StatefulWidget {
  String path;
  bool autoPlay;
  bool fullScreen; //默认全屏
  bool isAllowFullScreen; //是否显示全屏按钮
  bool isShowOptions; //是否显示又上角更多功能
  bool hero;

  VidwoPlayWidget(
      {
      required this.path,
      this.autoPlay = true,
      this.fullScreen = false,
      this.isAllowFullScreen = true,
      this.isShowOptions = true,
      this.hero = false,
      Key? key})
      : super(key: key);

  @override
  VidwoPlayWidgetState createState() => VidwoPlayWidgetState();
}

class VidwoPlayWidgetState extends State<VidwoPlayWidget> {
  VideoPlayerController? _controller;
  ChewieController? chewieController;
  bool _inited = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    if (!TextUtil.isEmpty(widget.path)) {
      _controller =  VideoManager.getVideoController(widget.path);
      if(_controller != null){
        Duration? duration;
        if(_controller?.value.isInitialized??false){
          _inited = true;
        }
        print('duration $duration');
        _controller?.addListener(_videoListener);
        chewieController = ChewieController(
            videoPlayerController: _controller!,
            startAt: duration,
            autoPlay: widget.autoPlay,
            autoInitialize: true,
            showOptions: widget.isShowOptions,
            allowFullScreen: widget.isAllowFullScreen,
            fullScreenByDefault: widget.fullScreen,
            looping: true,
            placeholder: Container(
              color: Colors.black,
            ));
      }
    }
  }

  _videoListener(){
    if(_controller?.value.isInitialized??false){
      setState(() {});
      _controller?.removeListener(_videoListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('isInitialized = ${chewieController?.videoPlayerController.value.isInitialized??false}');
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: (!TextUtil.isEmpty(widget.path))
          ? Hero(
            tag: widget.path,
            child: Center(
                child: chewieController?.videoPlayerController.value.isInitialized??false
                    ? Chewie(
                        controller: chewieController!,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                        ],
                      ),
              ),
          )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('VidwoPlayWidget dispose');
    if(!_inited){
      _controller?.dispose();
    }
    if(chewieController!=null){
      chewieController?.dispose();
    }
  }
}
