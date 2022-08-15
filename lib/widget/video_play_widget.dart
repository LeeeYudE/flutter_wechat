import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat/controller/video_manager.dart';
import 'package:wechat/widget/cache_image_widget.dart';
import 'package:wechat/widget/video_controls.dart';

import '../core.dart';
import '../main.dart';


class VidwoPlayWidget extends StatefulWidget {
  String path;
  bool autoPlay;
  bool isShowOptions; //是否显示又上角更多功能
  bool showControls; //是否显示又上角更多功能
  bool hero;
  String? videoCover;
  String? cacheId;

  VidwoPlayWidget(
      {
      required this.path,
      this.autoPlay = true,
      this.isShowOptions = true,
      this.hero = false,
      this.showControls = true,
      this.videoCover,
      this.cacheId,
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
      _videoPlayerController =  VideoManager.getVideoController(widget.path,cacheId:widget.cacheId);
      if(_videoPlayerController != null){
        if(_videoPlayerController?.value.isInitialized??false){
          _inited = true;
        }
        _videoPlayerController?.addListener(_videoListener);
        chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            autoPlay: widget.autoPlay,
            autoInitialize: !_inited,
            showOptions: widget.isShowOptions,
            fullScreenByDefault: false,
            showControls: widget.showControls,
            looping: true,
            customControls: const VideoControls(),
            placeholder: Container(
              color: Colors.black,
            ),
          allowFullScreen: false,
          allowMuting: false
        );
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
    print('isInitialized = ${chewieController?.videoPlayerController.value.isInitialized} ${widget.path}');
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
          ) : (widget.videoCover != null)?
          _buildCover():
          const CircularProgressIndicator(),
        ),
      ) : Container(),
    );
  }

  _buildCover(){
   return CacheImageWidget(weightWidth: double.infinity, url: widget.videoCover!, weightHeight:  double.infinity,);
  }

  
  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute); //订阅
    super.didChangeDependencies();
  }

  @override
  void didPush() {
    debugPrint('didPush');
    _videoPlayerController?.pause();
    super.didPush();
  }

  @override
  void didPushNext() {
    debugPrint('didPushNext');
    _videoPlayerController?.pause();
    super.didPushNext();
  }

  @override
  void didPop() {
    debugPrint('didPop');
    // _videoPlayerController?.play();
    super.didPop();
  }

  @override
  void didPopNext() {
    debugPrint('didPopNext');
    // _videoPlayerController?.play();
    super.didPopNext();
  }


  @override
  void dispose() {
    super.dispose();
    debugPrint('VidwoPlayWidget dispose $_inited');
    routeObserver.unsubscribe(this);
    if(widget.cacheId == null){
      _videoPlayerController?.dispose();
      VideoManager.removeChewieController(widget.path);
    }
    chewieController?.dispose();
  }
}
