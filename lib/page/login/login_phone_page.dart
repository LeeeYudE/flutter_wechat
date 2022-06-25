import 'package:flutter/material.dart';
import 'package:wechat/core.dart';
import '../../base/base_view.dart';
import '../../color/colors.dart';
import '../../language/strings.dart';
import '../../widget/base_scaffold.dart';
import '../../widget/common_btn.dart';
import '../../widget/input_field.dart';
import 'controller/login_phone_controller.dart';

class LoginPhonePage extends BaseGetBuilder<LoginPhoneController> {
  static const String routeName = '/LoginPhonePage';

  LoginPhonePage({Key? key}) : super(key: key);

  @override
  LoginPhoneController? getController() => LoginPhoneController();

  @override
  Widget controllerBuilder(BuildContext context, LoginPhoneController controller) {
    return MyScaffold(
      backIcon: Icons.close,
      body: _buildBody(context,controller),
    );
  }

  _buildBody(BuildContext context, LoginPhoneController controller) {
    return Container(
      color: Colours.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          50.sizedBoxH,
          Text(
            Ids.phone_login.str(),
            style: TextStyle(color: Colours.black, fontSize: 36.sp),
          ),
          50.sizedBoxH,
          _buildOperateLayout(
              Ids.phone.str(),
              Text(controller.phone,style: TextStyle(color: Colours.c_999999,fontSize: 32.sp),)),
          20.sizedBoxH,
          _buildOperateLayout(
              Ids.password.str(),
              InputField(
                hint: Ids.input_password.str(),
                controller: controller.passwordController,
              )),
          const Spacer(),
          _builcConfirmBtn(controller),
          200.sizedBoxH,
        ],
      ),
    );
  }

  _buildOperateLayout(String hint, Widget operate) {
    return Container(
      height: 100.w,
      width: double.infinity,
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(width: 1.w, color: Colours.c_999999.withOpacity(0.3)))),
      child: Row(
        children: [
          20.sizedBoxW,
          SizedBox(
              width: 180.w,
              child: Text(
                hint,
                style: TextStyle(color: Colours.black, fontSize: 32.sp),
              )),
          Expanded(child: operate),
        ],
      ),
    );
  }

  _builcConfirmBtn(LoginPhoneController controller) {
    bool enable = controller.passwordController.text.isNotEmpty;
    return CommonBtn(
      text: Ids.login.str(),
      onTap: () {
        controller.login();
      },
      textStyle: TextStyle(color: enable ? Colours.white : Colours.c_999999, fontSize: 32.sp),
      backgroundColor: enable ? Colours.theme_color : Colours.c_EEEEEE,
      height: 80.w,
      width: 300.w,
      enable: enable,
    );
  }
}
