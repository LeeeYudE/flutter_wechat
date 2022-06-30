import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:wechat/core.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/page/main/chat/chat_page.dart';
import 'package:wechat/page/main/chat/widget/chat_avatar.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../../color/colors.dart';
import '../../../../utils/navigator_utils.dart';

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
            ChatAvatar(conversation: conversation,),
            20.sizedBoxW,
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(conversation.title(),style: TextStyle(color: Colours.black,fontSize: 32.sp,height: 1),maxLines: 1,),
                Text('${conversation.lastMessage?.contentText}',style: TextStyle(color: Colours.c_999999,fontSize: 24.sp),maxLines: 1,),
              ],
            )),
            10.sizedBoxW,
            if(conversation.lastMessage?.sentTimestamp != null)
              Text(DateUtil.formatDateMs(conversation.lastMessage!.sentTimestamp!,format: 'mm:ss'),style: TextStyle(color: Colours.c_999999,fontSize: 24.sp,height: 1),),
          ],
        ),
      ),
    );
  }
}
