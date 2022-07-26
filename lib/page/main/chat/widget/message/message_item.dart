import 'package:flutter/material.dart';
import 'package:wechat/controller/member_controller.dart';
import 'package:wechat/core.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/page/main/contacts/friend_detail_page.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/avatar_widget.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../../../color/colors.dart';
import '../../model/red_packet_message.dart';
import 'message_location_item.dart';
import 'message_red_packet_item.dart';
import 'message_text_item.dart';

class MessageItem extends StatelessWidget {

  Message message;
  Message? lastMessage;

  final MemberController _memberController = MemberController.instance;

  MessageItem({required this.message,required this.lastMessage,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          _buildMsgTime(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: message.isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: message.isSend ?[
              _buildTypeItem(),
              20.sizedBoxW,
              _buildAvatar(),
            ]: [
              _buildAvatar(),
              20.sizedBoxW,
              _buildTypeItem(),
            ],
          ),
          20.sizedBoxH
        ],
      ),
    );
  }

  _buildAvatar(){
    return TapWidget(onTap: () {
      NavigatorUtils.toNamed(FriendDetailPage.routeName,arguments:message.fromClientID);
    },
    child: AvatarWidget(avatar: _memberController.getMember(message.fromClientID)?.avatar, weightWidth: 80.w,));
  }

  Widget _buildMsgTime() {
    bool showTime = false;
    if (lastMessage == null) {
      showTime = true;
    } else {
      if ((message.sentTimestamp??0) - (lastMessage?.sentTimestamp??0) > 300 * 1000) {///与上一条消息差距5分钟就显示时间
        showTime = true;
      }
    }

    return showTime ? Container(
        padding: EdgeInsets.only(bottom: 20.w),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 25.w,
            ),
            child: Text(
              "${message.sentTimestamp?.commonDateTime(showTime: true)}",
              style: TextStyle(
                fontSize: 24.sp,
                color: Colours.c_999999,
              ),
            ),
          ),
        )) : Container();
  }


  _buildTypeItem(){
    switch(message.messageType){
      case LCMessageExt.TYPE_TEXT:
        return MessageTextItem(message: message as TextMessage,);
      case LCMessageExt.TYPE_IMAGE:
        ImageMessage imageMessage = message as ImageMessage;
        break;
      case LCMessageExt.TYPE_LOCATION:
        return MessageLocationItem(message: message as LocationMessage,);
      case LCMessageExt.TYPE_RED_PACKET:
        return MessageRedPacketItem(message: message as RedPacketMessage,);
    }
    return SizedBox(
      height: 100.w,
      child: Center(
        child: Text(message.contentText,style: TextStyle(color: Colours.c_999999,fontSize: 32.sp),),
      ),
    );
  }

}
