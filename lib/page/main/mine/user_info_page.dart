
import 'package:flutter/material.dart';
import 'package:wechat/controller/member_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/tap_widget.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../color/colors.dart';
import '../../../controller/user_controller.dart';
import '../../../language/strings.dart';
import '../../../utils/dialog_util.dart';
import '../../../widget/avatar_widget.dart';
import '../../../widget/lable_widget.dart';
import '../../util/crop_image_page.dart';
import 'edit_nickname_page.dart';

class UserCenterPage extends StatefulWidget {

  static const String routeName = '/UserCenterPage';

  const UserCenterPage({Key? key}) : super(key: key);

  @override
  State<UserCenterPage> createState() => _UserCenterPageState();
}

class _UserCenterPageState extends State<UserCenterPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: Ids.user_center.str(),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildAvatar(context),
        Colours.c_EEEEEE.toLine(1.w),
        _buildNickname(),
      ],
    );
  }

  _buildAvatar(BuildContext context){
    return  LableWidget(lable:Ids.avatar.str(),rightWidget:AvatarWidget(avatar: UserController.instance.user?.avatar, weightWidth: 100.w,hero: true,),onTap:() async {
      var file = await DialogUtil.choosePhotoDialog(context,crop: true);
      if(file != null){
         var bool = await UserController.instance.updateAvatar(file);
         if(bool){
           setState(() {});
        }
      }
    });
  }

  _buildNickname(){
    return LableWidget(lable:Ids.nickname.str(),rightWidget:Text(UserController.instance.user?.nickname??'',style: TextStyle(color: Colours.black,fontSize: 28.sp,),),onTap:(){
      NavigatorUtils.toNamed(EditNicknamePage.routeName);
    });
  }

}
