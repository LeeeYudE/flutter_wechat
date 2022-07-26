import 'package:flutter/material.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/page/main/mine/setting_page.dart';
import 'package:wechat/page/main/mine/qrcode_business_card_page.dart';
import 'package:wechat/page/main/mine/user_info_page.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../language/strings.dart';
import '../../../utils/navigator_utils.dart';
import '../../../utils/utils.dart';
import '../../../widget/avatar_widget.dart';
import '../../../widget/right_arrow_widget.dart';
import '../../util/photo_preview_page.dart';

class MinePage extends BaseGetBuilder<UserController> {

  @override
  Widget controllerBuilder(BuildContext context, UserController controller) {
    return MyScaffold(
      showAppbar: false,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      color: Colours.c_EEEEEE,
      child: Column(
        children: [
          _buildHeader(),
          20.sizedBoxH,
          RightArrowWidget(lable: Ids.service.str(), callback: () {

          },leftIcon: Utils.getImgPath('ic_pay',dir:Utils.DIR_MINE),),
          20.sizedBoxH,
          RightArrowWidget(lable: Ids.favorite.str(), callback: () {

          },leftIcon: Utils.getImgPath('ic_card_package',dir:Utils.DIR_MINE),),
          1.sizedBoxH,
          RightArrowWidget(lable: Ids.friends_circle.str(), callback: () {

          },leftIcon: Utils.getImgPath('ic_setting',dir:Utils.DIR_MINE),),
          1.sizedBoxH,
          RightArrowWidget(lable: Ids.emoji.str(), callback: () {

          },leftIcon: Utils.getImgPath('ic_emoji',dir:Utils.DIR_MINE),),
          20.sizedBoxH,
          RightArrowWidget(lable: Ids.setting.str(), callback: () {
            NavigatorUtils.toNamed(SettingPage.routeName);
          },leftIcon: Utils.getImgPath('ic_setting',dir:Utils.DIR_MINE),),
        ],
      ),
    );
  }

  _buildHeader(){
    return TapWidget(
      onTap: () {
        NavigatorUtils.toNamed(UserCenterPage.routeName);
      },
      child: Container(
        color: Colours.white,
        padding: EdgeInsets.only(top: 200.w,left: 40.w,right: 40.w,bottom: 40.w),
        child: Row(
          children: [
            TapWidget(onTap: () {
              var avatar = UserController.instance.user?.avatar;
              if(!TextUtil.isEmpty(avatar)){
                PhotoPreviewPage.open(avatar!,heroTag: avatar);
              }
            },
            child: AvatarWidget(avatar: UserController.instance.user?.avatar, weightWidth: 150.w,hero: true,)),
            20.sizedBoxW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(UserController.instance.user?.nickname??'name',style: TextStyle(color: Colours.black,fontSize: 48.sp),),
                  10.sizedBoxH,
                  Text('WeChat ID:',style: TextStyle(color: Colours.black,fontSize: 24.sp),),
                  Text(UserController.instance.user?.wxId??'wxid',style: TextStyle(color: Colours.black,fontSize: 24.sp),),
                ],
              ),
            ),
            TapWidget(onTap: () {
              NavigatorUtils.toNamed(QrcodeBusinessCardPage.routeName);
            },
            child: Image.asset(Utils.getImgPath('ic_small_code',dir: Utils.DIR_MINE),width: 40.w,height: 40.w,)),
            20.sizedBoxW,
            Image.asset(Utils.getImgPath('ic_right_arrow_grey',dir: Utils.DIR_ICON,format: Utils.WEBP),width: 20.w,height: 20.w,),
          ],
        ),
      ),
    );
  }



  @override
  UserController? getController() => null;



}
