import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../../../controller/auido_manager.dart';
import 'audio_play_item.dart';

class MessageAudioItem extends StatelessWidget {

  AudioMessage message;

  MessageAudioItem({required this.message,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSend = message.isSend;
    return TapWidget(
      onTap: () {
        AudioManager().playMessage(message);
      },
      child: Container(
        width: 100.w + 10*(message.duration??0),
        height: 60.w,
        constraints: BoxConstraints(
          maxWidth: 300.w
        ),
        padding: EdgeInsets.symmetric(vertical: 10.w,horizontal: 10.w),
        decoration: (Colours.white).boxDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(()=> AudioPlayWidget(AudioManager.playAudioMessage.value == message,isSend)),
            Text(message.duration?.toString()??'',style: TextStyle(color: Colours.black,fontSize: 24.sp),)
          ],
        ),
      ),
    );
  }
}
