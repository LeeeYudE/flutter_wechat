import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:wechat/controller/chat_manager_controller.dart';
import 'package:wechat/core.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/page/main/chat/chat_page.dart';
import 'package:wechat/page/main/chat/widget/chat_avatar.dart';
import 'package:wechat/utils/utils.dart';
import 'package:wechat/widget/tap_widget.dart';
import 'package:wechat/widget/unread_widget.dart';

import '../../../../color/colors.dart';
import '../../../../language/strings.dart';
import '../../../../utils/navigator_utils.dart';
import '../../../../utils/pattern_util.dart';

class ChatItem extends StatefulWidget {

  final Conversation conversation;

  ChatItem({required this.conversation, Key? key}) : super(key: key);

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {

  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCustomPopupMenu(
      child: TapWidget(
        onTap: () {
          NavigatorUtils.toNamed(ChatPage.routeName,arguments:widget.conversation.id);
        },
        child: Container(
          color: widget.conversation.isPin?Colours.c_EEEEEE:Colours.white,
          padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.w),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 10.w,right: 10.w),
                      child: ChatAvatar(conversation: widget.conversation,)),
                  Container(
                      margin: EdgeInsets.only(left: 80.w,top: 10.w),
                      child: UnreadWidget(widget.conversation.unreadMessageCount))
                ],
              ),
              10.sizedBoxW,
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.conversation.title(),style: TextStyle(color: Colours.black,fontSize: 32.sp,height: 1),maxLines: 1,),
                  5.sizedBoxH,
                  PatternUtil.transformEmoji(widget.conversation.lastMessage?.contentText??'',TextStyle(color: Colours.c_999999,fontSize: 24.sp),imageSize: 32,maxLines: 1)
                ],
              )),
              10.sizedBoxW,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if(widget.conversation.lastMessage?.sentTimestamp != null)
                    Text("${widget.conversation.lastMessage?.sentTimestamp?.commonDateTime(showTime: true)}",style: TextStyle(color: Colours.c_999999,fontSize: 24.sp,height: 1),),
                    5.sizedBoxH,
                    if(widget.conversation.isMuted)
                      Image.asset(Utils.getIconImgPath('icon_chat_mute'),width: 30.w,height: 30.w,)
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomPopupMenu({required Widget child}){
    return CustomPopupMenu(
      child: child,
      showArrow: false,
      barrierColor: Colours.transparent,
      menuBuilder: () => Container(
        decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.circular(4.w),
          boxShadow: [
            BoxShadow(
              color: Colours.black.withOpacity(0.1),  //底色,阴影颜色
              offset: const Offset(0, 0), //阴影位置,从什么位置开始
              blurRadius: 1,  // 阴影模糊层度
              spreadRadius: 2,)  //阴影模糊大小
          ],
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPopupItem(Ids.mark_readed.str(),(){
                _controller.hideMenu();
                widget.conversation.read();
              }),
              _buildPopupItem((widget.conversation.isPin)?Ids.pin_cancel.str():Ids.pin_chat.str(),(){
                _controller.hideMenu();
                ChatManagerController.instance.chatPin(widget.conversation, !widget.conversation.isPin);
              }),
              _buildPopupItem(Ids.delete_chat.str(),()  {
                _controller.hideMenu();
                ChatManagerController.instance.deleteChat(widget.conversation);
              }),
            ],
          ),
        ),
      ),
      pressType: PressType.longPress,
      controller: _controller,
    );
  }

  _buildPopupItem(String lable,GestureTapCallback onTap){
   return  TapWidget(
     onTap: onTap,
     child: Container(
        height: 80.w,
        width: 260.w,
        padding: EdgeInsets.symmetric(horizontal: 40.w,vertical: 20.w),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10.w),
              child: Text(
                lable,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32.sp,
                ),
              ),
            ),
          ],
        ),
      ),
   );
  }



}
