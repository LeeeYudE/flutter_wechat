import 'package:flutter/material.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/page/login/login_phone_check_page.dart';
import 'package:wechat/page/login/register_page.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/utils/utils.dart';
import 'package:wechat/core.dart';

import '../../controller/user_controller.dart';
import '../../language/strings.dart';
import '../../widget/common_btn.dart';

class SplashPage extends BaseGetBuilder<UserController> {

  static const String routeName = '/';

  @override
  UserController? getController() => null;

  @override
  Widget controllerBuilder(BuildContext context, UserController controller) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(Utils.getImgPath('bg_launch',dir: 'bg'),width: double.infinity,height: double.infinity,fit: BoxFit.cover,),
          if(controller.isInited && controller.user == null)
            _buildLoginBtn()
        ],
      ),
    );
  }

  _buildLoginBtn(){
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 50.w,left: 40.w,right: 40.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonBtn(onTap: () {
                NavigatorUtils.toNamed(LoginPhoneCheckPage.routeName);
              }, text: Ids.login.str(),textStyle: TextStyle(color: Colours.white,fontSize: 28.sp),backgroundColor: Colours.c_00CE3E,borderRadius:12.w , height: 80.w, width: 200.w ,),
              CommonBtn(onTap: () {
                  NavigatorUtils.toNamed(RegisterPage.routeName);
              }, text: Ids.register.str(),textStyle: TextStyle(color: Colours.c_00CE3E,fontSize: 28.sp),backgroundColor: Colours.white,borderRadius:12.w, height: 80.w, width: 200.w ,
              ),
            ],
          ),
        ));
  }

}
