import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/core.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/page/main/chat/chat_page.dart';
import 'package:wechat/page/main/chat/widget/chat_avatar.dart';
import 'package:wechat/widget/tap_widget.dart';
import 'package:wechat/widget/unread_widget.dart';

import '../../../../color/colors.dart';
import '../../../../utils/navigator_utils.dart';
import '../../../../utils/pattern_util.dart';

class ChatItem extends StatelessWidget {

  final Conversation conversation;

  const ChatItem({required this.conversation, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapWidget(
      onTap: () {
        NavigatorUtils.toNamed(ChatPage.routeName,arguments:conversation.id);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.w),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10.w,right: 10.w),
                    child: ChatAvatar(conversation: conversation,)),
                Container(
                    margin: EdgeInsets.only(left: 80.w,top: 10.w),
                    child: UnreadWidget(conversation.unreadMessageCount))
              ],
            ),
            10.sizedBoxW,
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(conversation.title(),style: TextStyle(color: Colours.black,fontSize: 32.sp,height: 1),maxLines: 1,),
                5.sizedBoxH,
                PatternUtil.transformEmoji('${conversation.lastMessage?.contentText}',TextStyle(color: Colours.c_999999,fontSize: 24.sp),imageSize: 32)
              ],
            )),
            10.sizedBoxW,
            if(conversation.lastMessage?.sentTimestamp != null)
              Text("${conversation.lastMessage?.sentTimestamp?.commonDateTime(showTime: true)}",style: TextStyle(color: Colours.c_999999,fontSize: 24.sp,height: 1),),
          ],
        ),
      ),
    );
  }
}
