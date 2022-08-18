import 'package:flutter/material.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/login/test_accounts_page.dart';
import 'package:wechat/page/login/zone_code_page.dart';
import '../../base/base_view.dart';
import '../../color/colors.dart';
import '../../language/strings.dart';
import '../../utils/navigator_utils.dart';
import '../../widget/base_scaffold.dart';
import '../../widget/common_btn.dart';
import '../../widget/input_field.dart';
import '../../widget/tap_widget.dart';
import 'controller/login_phone_check_controller.dart';

class LoginPhoneCheckPage extends BaseGetBuilder<LoginPhoneCheckController> {
  static const String routeName = '/LoginPhoneCheckPage';

  LoginPhoneCheckPage({Key? key}) : super(key: key);

  @override
  LoginPhoneCheckController? getController() => LoginPhoneCheckController();

  @override
  Widget controllerBuilder(BuildContext context, LoginPhoneCheckController controller) {
    return MyScaffold(
      backIcon: Icons.close,
      body: _buildBody(context, controller),
    );
  }

  _buildBody(BuildContext context, LoginPhoneCheckController controller) {
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
              Ids.country_and_area.str(),
              TapWidget(
                  onTap: () async {
                    var zoneCode = await NavigatorUtils.toNamed(ZoneCodePage.routeName);
                    if (zoneCode != null) {
                      controller.changeZoneCode(zoneCode);
                    }
                  },
                  child: Text(
                    '${controller.currZone.name}' '(+${controller.currZone.tel})',
                    style: TextStyle(color: Colours.c_999999, fontSize: 32.sp),
                  ))),
          20.sizedBoxH,
          _buildOperateLayout(
              Ids.phone.str(),
              InputField(
                hint: Ids.phone_input_hint.str(),
                controller: controller.phoneController,
                inputType: TextInputType.phone,
              )),
          20.sizedBoxH,
          TapWidget(onTap: () async {
           var account =  await NavigatorUtils.toNamed(TestAccountsPage.routeName);
           if(account != null){
             controller.phoneController.newValue(account);
           }
          },
          child: Text('测试账号',style: TextStyle(color: Colours.c_999999,fontSize: 32.sp),)),
          const Spacer(),
          Text(
            Ids.phone_only_use_check.str(),
            style: TextStyle(color: Colours.c_999999, fontSize: 24.sp),
          ),
          40.sizedBoxH,
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

  _builcConfirmBtn(LoginPhoneCheckController controller) {
    bool enable = controller.phoneController.text.isNotEmpty;

    return CommonBtn(
      text: Ids.agree_and_continue.str(),
      onTap: () {
        controller.checkPhone();
      },
      textStyle: TextStyle(color: enable ? Colours.white : Colours.c_999999, fontSize: 32.sp),
      backgroundColor: enable ? Colours.theme_color : Colours.c_EEEEEE,
      height: 80.w,
      width: 300.w,
      enable: enable,
    );
  }
}
