import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat/controller/video_manager.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/util/video_perview_page.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/tap_widget.dart';
import '../base/constant.dart';
import '../main.dart';
import 'cache_image_widget.dart';

class ScaleSizeVideoWidget extends StatefulWidget {

  double photoWidth;
  double photoHeight;
  String photoUrl;
  String videoUrl;

  ScaleSizeVideoWidget({required this.photoWidth , required this.photoHeight , required this.photoUrl,required this.videoUrl,Key? key}) : super(key: key);

  @override
  State<ScaleSizeVideoWidget> createState() => _ScaleSizeVideoWidgetState();
}

class _ScaleSizeVideoWidgetState extends State<ScaleSizeVideoWidget> with RouteAware {

  late VideoPlayerController _videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  _initVideo() async {
    _videoPlayerController = VideoManager.getVideoController(widget.videoUrl,cache: false);
    _videoPlayerController.addListener(_videoListener);
    chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        autoInitialize: false,
        showOptions: false,
        allowFullScreen: true,
        fullScreenByDefault: false,
        showControls: false,
        looping: true,
        placeholder: Container(
          color: Colors.black,
        ));
    setState(() {});
  }

  _videoListener() async {
    if(_videoPlayerController.value.isInitialized){
      setState(() {});
      _videoPlayerController.removeListener(_videoListener);
      await chewieController.videoPlayerController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    double _photoWidth = widget.photoWidth;
    double _photoHeight = widget.photoHeight;
    final double scale = _photoWidth / _photoHeight;
    if (_photoWidth == 0) {
      _photoWidth = Constant.MAX_PHOTO_WIDTH;
      _photoHeight = Constant.MAX_PHOTO_HEIGHT;
    } else if (_photoWidth < Constant.MIN_PHOTO_WIDTH && _photoHeight < Constant.MIN_PHOTO_HEIGHT) {
      _photoWidth = Constant.MIN_PHOTO_WIDTH ;
      _photoHeight = _photoWidth / scale;
    } else if (_photoWidth > Constant.MIN_PHOTO_WIDTH  &&
        _photoWidth < Constant.MAX_PHOTO_WIDTH &&
        _photoHeight > Constant.MIN_PHOTO_HEIGHT &&
        _photoHeight < Constant.MAX_PHOTO_HEIGHT) {
      _photoWidth = widget.photoWidth;
      _photoHeight = widget.photoHeight;
    } else {
      if (_photoWidth >= _photoHeight) {
        _photoWidth = Constant.MAX_PHOTO_WIDTH;
        _photoHeight = _photoWidth / scale;
      } else {
        _photoHeight = Constant.MAX_PHOTO_HEIGHT;
        _photoWidth = _photoHeight * scale;
      }
    }
    if(_videoPlayerController.value.isInitialized){
      return TapWidget(
        onTap: ()  async {
         await  NavigatorUtils.toNamed(VideoPerviewPage.routeName,arguments:VideoArguments(url: widget.videoUrl,hero: true));
         // _videoPlayerController.play();
        },
        child: SizedBox(
          width: _photoWidth,
          height: _photoHeight,
          child: Hero(
            tag: widget.videoUrl,
            child: Chewie(
              controller: chewieController,
            ),
          ),
        ),
      );
    }else{
      return CacheImageWidget(url: widget.photoUrl, weightWidth: _photoWidth, weightHeight: _photoHeight,hero: true,clipRRect: false,);
    }

  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute); //订阅
    super.didChangeDependencies();
  }

  @override
  void didPush() {
    _videoPlayerController.pause();
    super.didPush();
  }

  @override
  void didPushNext() {
    _videoPlayerController.pause();
    super.didPushNext();
  }

  @override
  void didPop() {
    _videoPlayerController.play();
    super.didPop();
  }

  @override
  void didPopNext() {
    _videoPlayerController.play();
    super.didPopNext();
  }

  @override
  void dispose() {
    super.dispose();
    chewieController.dispose();
    _videoPlayerController.dispose();
    routeObserver.unsubscribe(this);
    VideoManager.removeChewieController(widget.videoUrl);
  }

}
