import 'package:flutter/material.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/core.dart';
import '../../../base/common_state_widget_x.dart';
import '../../../color/colors.dart';
import '../../../controller/user_controller.dart';
import '../../../language/strings.dart';
import '../../../utils/utils.dart';
import '../../../widget/avatar_widget.dart';
import '../../../widget/tap_widget.dart';
import 'controller/friend_detail_controller.dart';

class FriendDetailPage extends BaseGetBuilder<FriendDetailController> {

  static const String routeName = '/FriendDetailPage';

   FriendDetailPage({Key? key}) : super(key: key);

  @override
  FriendDetailController? getController()  => FriendDetailController();

  @override
  Widget controllerBuilder(BuildContext context, FriendDetailController controller) {
    return MyScaffold(
      appbarColor: Colours.white,
      actions: [
        TapWidget(onTap: () async {}, child: Image.asset(Utils.getImgPath('ic_more_black',dir: Utils.DIR_ICON,),width: 40.w,height: 40.w,))
      ],
      body: _buildBody(context,controller),
    );
  }


  Widget _buildBody(BuildContext context, FriendDetailController controller) {
    return CommonStateWidgetX(
      controller: controller,
      widgetBuilder: (BuildContext context) {
        return  Column(
          children: [
            Container(
              padding: EdgeInsets.all(40.w),
              color: Colours.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AvatarWidget(avatar: controller.friend?.avatar, weightWidth: 150.w,),
                  20.sizedBoxW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.friend?.nickname??'name',style: TextStyle(color: Colours.black,fontSize: 48.sp),),
                        10.sizedBoxH,
                        Row(
                          children: [
                            Text('WeChat ID:',style: TextStyle(color: Colours.black,fontSize: 24.sp),),
                            Expanded(child: Text(UserController.instance.user?.wxId??'wxid',style: TextStyle(color: Colours.black,fontSize: 24.sp),maxLines: 1,)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            20.sizedBoxH,
            _buildFriendCircle(),
            20.sizedBoxH,
            if(controller.isFriend)
              _buildSendMessage(controller)
            else
              _buildAddContacts(controller)
          ],
        );
      },
    );
  }

  _buildFriendCircle(){
    return Container(
      height: 120.w,
      color: Colours.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(Ids.friends_circle.str(),style: TextStyle(color: Colours.black,fontSize: 32.sp),)
        ],
      ),
    );
  }

  _buildAddContacts(FriendDetailController controller){
    return TapWidget(
      onTap: () {
        controller.addContacts();
      },
      child: Container(
        height: 100.w,
        color: Colours.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Ids.add_to_contacts.str(),style: TextStyle(color: Colours.c_5B6B8D,fontSize: 32.sp,),)
          ],
        ),
      ),
    );
  }

  _buildSendMessage(FriendDetailController controller){
    return TapWidget(
      onTap: () {

      },
      child: Container(
        height: 100.w,
        color: Colours.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Ids.send_message.str(),style: TextStyle(color: Colours.c_5B6B8D,fontSize: 32.sp),)
          ],
        ),
      ),
    );
  }

}
