import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/util/photo_preview_page.dart';
import 'package:wechat/widget/scale_size_image_widget.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../../../controller/auido_manager.dart';
import '../../../../../utils/navigator_utils.dart';
import 'audio_play_item.dart';

class MessageImageItem extends StatelessWidget {

  ImageMessage message;

  MessageImageItem({required this.message,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleSizeImageWidget(photoHeight: message.height??0, photoWidth: message.width??0, photoUrl: message.url??'',);
  }
}
