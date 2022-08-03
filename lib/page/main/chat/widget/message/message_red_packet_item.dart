import 'package:flutter/material.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/language/strings.dart';
import 'package:wechat/page/main/chat/model/red_packet_message.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../../../utils/pattern_util.dart';
import '../../../../../utils/utils.dart';
import '../../page/red_packet/red_packet_preview_page.dart';

class MessageRedPacketItem extends StatelessWidget {

  RedPacketMessage message;

  MessageRedPacketItem({required this.message,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapWidget(
      onTap: () {
        NavigatorUtils.toNamed(RedPacketPreviewPage.routeName,arguments: message);
      },
      child: Container(
        width: 400.w,
        padding: EdgeInsets.symmetric(vertical: 10.w,horizontal: 20.w),
        decoration: (Colours.c_FA9E3B).boxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.sizedBoxH,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Utils.getImgPath('ic_red_packet',dir: Utils.DIR_CHAT,),width: 80.w,height: 80.w,),
                Text(message.text??'',style: TextStyle(color: Colours.white,fontSize: 28.sp),),
              ],
            ),
            10.sizedBoxH,
            Colours.c_EEEEEE.toLine(0.5.w),
            10.sizedBoxH,
            Text(Ids.red_package.str(),style: TextStyle(color: Colours.c_EEEEEE,fontSize: 18.sp),)
          ],
        ),
      ),
    );
  }
}
