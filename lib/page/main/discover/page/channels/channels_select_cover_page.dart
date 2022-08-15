import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_editor/domain/bloc/controller.dart';
import 'package:video_editor/domain/entities/trim_style.dart';
import 'package:video_editor/ui/cover/cover_viewer.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/common_btn.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../../../language/strings.dart';
import '../../../../../utils/dialog_util.dart';
import '../../../../../utils/navigator_utils.dart';
import '../../../../../widget/video_cover_selection.dart';

class ChannelsSelectCoverPage extends StatefulWidget {

  static const String routeName = '/ChannelsSelectCoverPage';

  const ChannelsSelectCoverPage({Key? key}) : super(key: key);

  @override
  State<ChannelsSelectCoverPage> createState() => _ChannelsSelectCoverPageState();
}

class _ChannelsSelectCoverPageState extends State<ChannelsSelectCoverPage> {

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
        showLeading: false,
        backgroundColor: Colours.black,
        appbarColor: Colours.black,
        body: _buildContext(context)
    );
  }

  Widget _buildContext(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: (_controller.video.value.isInitialized)? CoverViewer(
            controller: _controller,
          ):Container(),
        ),
        Container(
          height: 150.w,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: (_controller.video.value.isInitialized)?VideoCoverSelection(
            controller: _controller,
            height: 150.w,
            quantity: 12,
            quality: 90 ,
          ):null,
        ),
        _buildBottomBar(),
      ],
    );
  }

  _buildBottomBar(){
    return Container(
      height: 150.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TapWidget(onTap: () {
            NavigatorUtils.pop();
          },
          child: Text(Ids.cancel.str(),style: TextStyle(color: Colours.white,fontSize: 32.sp),)),
          CommonBtn(text: Ids.confirm.str(), onTap: (){
            DialogUtil.showLoading();
            _controller.extractCover(onCompleted: (file){
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
