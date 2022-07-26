import 'package:flutter/material.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/controller/member_controller.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/page/main/chat/controller/chat_detail_controller.dart';
import 'package:wechat/page/main/chat/qrcode_group_chat_page.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/avatar_widget.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/common_switch.dart';
import 'package:wechat/widget/lable_widget.dart';
import 'package:wechat/widget/tap_widget.dart';
import '../../../color/colors.dart';
import '../../../controller/chat_manager_controller.dart';
import '../../../language/strings.dart';
import '../../../utils/utils.dart';
import '../../../widget/base_scaffold.dart';
import '../../../widget/dialog/dialog_bottom_widget.dart';
import '../contacts/select_friend_page.dart';
import 'chat_group_edit_name_page.dart';

class ChatDetailPage extends BaseGetBuilder<ChatDetailContoller> {

  static const String routeName = '/ChatDetailPage';

  ChatDetailPage({Key? key}) : super(key: key);

  @override
  ChatDetailContoller? getController() => ChatDetailContoller();

  @override
  Widget controllerBuilder(BuildContext context, ChatDetailContoller controller) {
    return MyScaffold(
      title: Ids.chat_info.str(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildAvatarHeader(context),
        if(controller.conversation.isGroup)
          Colours.c_EEEEEE.toLine(10.w),
        if(controller.conversation.isGroup)
        _buildGroupInfo(),
        Colours.c_EEEEEE.toLine(10.w),
        _buildChatSetting(),
        if(controller.conversation.isGroup)
          _buildQuit()
      ],
    );
  }

  Widget _buildAvatarHeader(BuildContext context) {
    List<Widget> footWidgets = [];
    footWidgets.add(TapWidget(
      onTap: () async {
        var usernames = await NavigatorUtils.toNamed(SelectFriendPage.routeName,arguments: SelectFriendArguments(title: Ids.create_chat.str(),selectedUsername: controller.conversation.membersStr));
        if(usernames != null){
          if(controller.conversation.isGroup){
            controller.inviteMember(usernames);
          }else{
            Set<String> members = usernames;
            controller.conversation.members?.forEach((element) {
              members.add(element);
            });
            ChatManagerController.instance.createConversation(usernames);
          }
        }
      },
      child: Column(
        children: [
          Image.asset(Utils.getChatImgPath('icon_add_member'),width: 100.w,height: 100.w,),
          const Spacer()
        ],
      ),
    ));
    if(controller.conversation.isGroup && controller.conversation.creator == UserController.instance.username){
      footWidgets.add(Column(
        children: [
          Image.asset(Utils.getChatImgPath('icon_min_member'),width: 100.w,height: 100.w,),
          const Spacer()
        ],
      ));
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.w),
      color: Colours.white,
      child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 5,
      mainAxisSpacing: 20.w,
      crossAxisSpacing: 20.w,
      childAspectRatio: 0.8,
      ),itemBuilder: (context , index){
        if(index < controller.conversation.members!.length){
          var username =  controller.conversation.members![index];
          var member = MemberController.instance.getMember(username);
          return Column(
            children: [
              AvatarWidget(avatar:member?.avatar, weightWidth: 100.w),
              5.sizedBoxH,
              Text(member?.nickname??'name',style: TextStyle(color: Colours.c_999999,fontSize: 24.sp),),
            ],
          );
        }
       return footWidgets[index - controller.conversation.members!.length];
      },itemCount: (controller.conversation.members?.length??0) + footWidgets.length,shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),),
    );
  }

  Widget _buildGroupInfo(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LableWidget(lable: Ids.group_chat_name.str(),rightWidget: Text(controller.conversation.title(),style: TextStyle(color: Colours.c_999999,fontSize: 28.sp),),onTap: () async {
          var name = await NavigatorUtils.toNamed(ChatGroupEditNamePage.routeName,arguments: controller.conversation);
          if(name != null){
            controller.updateChatName(name);
          }
        },),
        Colours.c_EEEEEE.toLine(1.w),
        LableWidget(lable: Ids.group_chat_code.str(),rightWidget: Image.asset(Utils.getImgPath('ic_small_code',dir: Utils.DIR_MINE),width: 40.w,height: 40.w,),onTap: (){
          NavigatorUtils.toNamed(QrcodeGroupChatPage.routeName,arguments: controller.conversation);
        },),
        Colours.c_EEEEEE.toLine(1.w),
        LableWidget(lable: Ids.group_chat_announcement.str(),),
      ],
    );
  }

  Widget _buildChatSetting(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LableWidget(lable: Ids.message_no_disturbing.str(),rightWidget: CommonSwitch(status: controller.conversation.isMuted,onChange: (mute){
          controller.chatMute(mute);
        },),showArrow: false),
        Colours.c_EEEEEE.toLine(1.w),
        LableWidget(lable: Ids.pin_chat.str(),rightWidget: CommonSwitch(status: controller.conversation.isPin,onChange: (pin){
          controller.chatPin(pin);
        },),showArrow: false,),
      ],
    );
  }

  Widget _buildQuit(){
    return Container(
      margin: EdgeInsets.only(top: 20.w),
      child: TapWidget(
        onTap: () async {
          var result = await NavigatorUtils.showBottomItemsDialog([DialogBottomWidgetItem(Ids.delete_and_quit.str(),0)]);
          if(result == 0){
            controller.quit();
          }

        },
        child: Container(
          color: Colours.white,
          height: 100.w,
          child: Center(
            child: Text(Ids.delete_and_quit.str(),style: TextStyle(color: Colours.c_E63E24,fontSize: 32.sp),),
          ),
        ),
      ),
    );
  }

}
