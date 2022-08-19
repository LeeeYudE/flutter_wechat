import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/util/photo_preview_page.dart';
import 'package:wechat/page/util/video_perview_page.dart';
import 'package:wechat/utils/utils.dart';
import 'package:wechat/widget/scale_size_image_widget.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../../../controller/auido_manager.dart';
import '../../../../../utils/navigator_utils.dart';
import 'audio_play_item.dart';

class MessageVideoItem extends StatelessWidget {

  VideoMessage message;

  MessageVideoItem({required this.message,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapWidget(
      onTap: () {
        NavigatorUtils.toNamed(VideoPerviewPage.routeName,arguments: VideoArguments(url: message.url??'',autoPlay: true,));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ScaleSizeImageWidget(photoHeight: message.thumbnailHeight, photoWidth: message.thumbnailWidth, photoUrl: message.thumbnailUrl??'',tapDetail: false,),
          Container(
              decoration: Colours.white.boxDecoration(borderRadius: 60.w),
              child: Icon(Icons.play_circle,color: Colours.c_CCCCCC,size: 60.w,))
        ],
      ),
    );
  }
}
