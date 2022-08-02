import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat/controller/video_manager.dart';

import '../core.dart';
import '../main.dart';

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

class VidwoPlayWidgetState extends State<VidwoPlayWidget>  with RouteAware {
  VideoPlayerController? _videoPlayerController;
  ChewieController? chewieController;
  bool _inited = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    if (!TextUtil.isEmpty(widget.path)) {
      _videoPlayerController =  VideoManager.getVideoController(widget.path);
      if(_videoPlayerController != null){
        Duration? duration;
        if(_videoPlayerController?.value.isInitialized??false){
          _inited = true;
        }
        print('duration $duration');
        _videoPlayerController?.addListener(_videoListener);
        chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
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
    if(_videoPlayerController?.value.isInitialized??false){
      setState(() {});
      _videoPlayerController?.removeListener(_videoListener);
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
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute); //订阅
    super.didChangeDependencies();
  }

  @override
  void didPush() {
    _videoPlayerController?.pause();
    super.didPush();
  }

  @override
  void didPushNext() {
    _videoPlayerController?.pause();
    super.didPushNext();
  }

  @override
  void didPop() {
    _videoPlayerController?.play();
    super.didPop();
  }

  @override
  void didPopNext() {
    _videoPlayerController?.play();
    super.didPopNext();
  }


  @override
  void dispose() {
    super.dispose();
    debugPrint('VidwoPlayWidget dispose');
    routeObserver.unsubscribe(this);
    if(!_inited){
      _videoPlayerController?.dispose();
    }
    if(chewieController!=null){
      chewieController?.dispose();
    }
  }
}
