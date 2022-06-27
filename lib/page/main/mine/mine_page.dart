import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/page/main/mine/qrcode_business_card_page.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../utils/navigator_utils.dart';
import '../../../utils/utils.dart';
import '../../../widget/avatar_widget.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      showAppbar: false,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      color: Colours.c_CCCCCC,
      child: Column(
        children: [
          _buildHeader()
        ],
      ),
    );
  }

  _buildHeader(){
    return Container(
      color: Colours.white,
      padding: EdgeInsets.only(top: 200.w,left: 40.w,right: 40.w,bottom: 40.w),
      child: Row(
        children: [
          AvatarWidget(avatar: UserController.instance.user?.avatar, weightWidth: 150.w,),
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
          Image.asset(Utils.getImgPath('ic_right_arrow_grey',dir: Utils.DIR_ICON,format: Utils.WEBP),width: 40.w,height: 40.w,),
        ],
      ),
    );
  }

}
