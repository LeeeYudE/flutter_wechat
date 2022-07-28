import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../core.dart';

class VidwoPlayWidget extends StatefulWidget {
  String path;
  bool autoPlay;
  bool fullScreen; //默认全屏
  bool isPlayBack; //播放完后退出
  bool isAllowFullScreen; //是否显示全屏按钮
  bool isShowOptions; //是否显示又上角更多功能

  VidwoPlayWidget(
      {
      required this.path,
      this.autoPlay = true,
      this.fullScreen = false,
      this.isPlayBack = false,
      this.isAllowFullScreen = true,
      this.isShowOptions = true,
      Key? key})
      : super(key: key);

  @override
  VidwoPlayWidgetState createState() => VidwoPlayWidgetState();
}

class VidwoPlayWidgetState extends State<VidwoPlayWidget> {
  VideoPlayerController? _controller;
  ChewieController? chewieController;
  bool _full = false;
  bool _abort = false; //防止退出多次

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    if (!TextUtil.isEmpty(widget.path)) {
      if (widget.path.startsWith('http')) {
        _controller = VideoPlayerController.network(widget.path);
      } else {
        final file = File(widget.path);
        _controller = VideoPlayerController.file(file);
      }
      chewieController?.addListener(() {
        print('chewieController addListener = ${chewieController?.isPlaying}');
      });
      _controller?.addListener(() async {
        print('_controller addListener = ${chewieController?.isPlaying}');
        if (!_full && (chewieController?.isPlaying ?? false)) {
          _full = true;
          print('_controller addListener = setState');
          setState(() {});
        }
        if (widget.isPlayBack &&
            _controller != null &&
            !_abort &&
            _controller!.value.position >= _controller!.value.duration) {
          _abort = true;

          Navigator.of(context).pop();
        }
      });
      await _controller?.initialize();
      if(_controller != null) {
        chewieController = ChewieController(
          videoPlayerController: _controller!,
          autoPlay: widget.autoPlay,
          autoInitialize: true,
          showOptions: widget.isShowOptions,
          allowFullScreen: widget.isAllowFullScreen,
          fullScreenByDefault: widget.fullScreen,
          placeholder: Container(
            color: Colors.black,
          ));
      }
    }
  }

  restart() async {
    await chewieController!.seekTo(const Duration(seconds: 0));
    chewieController!.play();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: (!TextUtil.isEmpty(widget.path))
          ? Center(
              child: chewieController != null &&
                      chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: chewieController!,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                      ],
                    ),
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('VidwoPlayWidget dispose');
    _controller?.dispose();
    if(chewieController!=null){
      chewieController?.dispose();
    }
  }
}
