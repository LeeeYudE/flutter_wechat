import 'package:flutter/cupertino.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/login/splash_page.dart';
import 'package:wechat/page/main/mine/language_setting_page.dart';
import 'package:wechat/page/util/uniapp_util_page.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../color/colors.dart';
import '../../../language/strings.dart';
import '../../../utils/navigator_utils.dart';
import '../../../widget/right_arrow_widget.dart';

class SettingPage extends StatelessWidget {

  static const String routeName = '/SettingPage';

  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: Ids.setting.str(),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Column(
      children: [
        RightArrowWidget(lable: Ids.account_and_safety.str(), callback: () {

        },),
        20.sizedBoxH,
        RightArrowWidget(lable: Ids.new_message_notify.str(), callback: () {

        },),
        20.sizedBoxH,
        RightArrowWidget(lable: Ids.chat.str(), callback: () {

        },),
        1.sizedBoxH,
        RightArrowWidget(lable: Ids.common.str(), callback: () {

        },),
        1.sizedBoxH,
        RightArrowWidget(lable: Ids.friend_permission.str(), callback: () {

        },),
        1.sizedBoxH,
        RightArrowWidget(lable: Ids.language.str(), callback: () {
          NavigatorUtils.toNamed(LanguageSettingPage.routeName);
        },),
        20.sizedBoxH,
        RightArrowWidget(lable: Ids.about_wechat.str(), callback: () {

        },),
        20.sizedBoxH,
        RightArrowWidget(lable: Ids.help_and_feedback.str(), callback: () {

        },),
        20.sizedBoxH,
        RightArrowWidget(lable: Ids.mini_program_update_util.str(), callback: () {
            NavigatorUtils.toNamed(UniappUtilPage.routeName);
        },),
        20.sizedBoxH,
        TapWidget(
          onTap: () async {
            await UserController.instance.logout();
            NavigatorUtils.offAllNamed(SplashPage.routeName);
          },
          child: Container(
            width: double.infinity,
            color: Colours.white,
            height: 100.w,
            child: Center(
              child: Text(Ids.logout.str(),style: TextStyle(color: Colours.black,fontSize: 32.sp),),
            ),
          ),
        ),
      ],
    );
  }
}
