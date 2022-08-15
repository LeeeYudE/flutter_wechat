import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/utils/dialog_util.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:video_editor/video_editor.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/common_btn.dart';
import 'package:helpers/helpers.dart' show OpacityTransition, SwipeTransition, AnimatedInteractiveViewer;
import '../../../../../language/strings.dart';
import '../../../../../utils/navigator_utils.dart';
import 'channels_create_page.dart';

class ChannelsVideoEditPage extends StatefulWidget {

  static const String routeName = '/VideoEditPage';

  ChannelsVideoEditPage({Key? key}) : super(key: key);

  @override
  State<ChannelsVideoEditPage> createState() => _ChannelsVideoEditPageState();
}

class _ChannelsVideoEditPageState extends State<ChannelsVideoEditPage> {

  late File _video;
  late VideoEditorController _controller;

  @override
  void initState() {
    _video = Get.arguments;
    _initController();
    super.initState();
  }

  _initController() {
    _controller = VideoEditorController.file(_video,maxDuration: const Duration(seconds: 30),trimStyle:TrimSliderStyle(
        lineWidth: 5.w,lineColor: Colours.white
    ) );
    _controller.initialize().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appbarColor: Colours.black,
      backgroundColor: Colours.black,
      backIconColor: Colours.white,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Column(
        children: [
          _buildVideo(),
          _buildTrimSlider(),
          _buildBottomBar()
        ],
      ),
    );
  }

  _buildVideo(){
    return  Expanded(
      child: Stack(alignment: Alignment.center, children: [
        CropGridViewer(
          controller: _controller,
          showGrid: false,
        ),
        AnimatedBuilder(
          animation: _controller.video,
          builder: (_, __) => OpacityTransition(
            visible: !_controller.isPlaying,
            child: GestureDetector(
              onTap: _controller.video.play,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow,
                    color: Colors.black),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  _buildTrimSlider(){
    return Container(
      height: 150.w,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child:(_controller.video.value.isInitialized)? TrimSlider(
        controller: _controller,
        height: 150.w,):null,
    );
  }

  _buildBottomBar(){
    return Container(
      height: 150.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CommonBtn(text: Ids.confirm.str(), onTap: () async {

            if(_controller.startTrim == Duration.zero && _controller.endTrim == _controller.video.value.duration){
              NavigatorUtils.pop(_video);
              return ;
            }
            DialogUtil.showLoading();
            _controller.exportVideo(onCompleted: (file){
              DialogUtil.disimssLoading();
              NavigatorUtils.pop(file);
            });
          })
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}
