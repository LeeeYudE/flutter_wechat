import 'package:flutter/gestures.dart';
import 'package:wechat/core.dart';
import 'package:wechat/base/base_view.dart';
import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/page/login/controller/register_controller.dart';
import 'package:wechat/page/login/zone_code_page.dart';
import 'package:wechat/page/util/webview_page.dart';
import 'package:wechat/utils/dialog_util.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/common_btn.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../base/constant.dart';
import '../../language/strings.dart';

import '../../utils/utils.dart';
import '../util/crop_image_page.dart';

class RegisterPage extends BaseGetBuilder<RegisterController> {

  static const String routeName = '/RegisterPage';

  RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterController? getController() => RegisterController();

  @override
  Widget controllerBuilder(BuildContext context, RegisterController controller) {
    return MyScaffold(
      appbarColor: Colours.white,
      brightness: Brightness.light,
      leading: IconButton(icon: const Icon(Icons.close,color: Colours.c_999999,), onPressed: () {
        NavigatorUtils.pop();
      },),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      color: Colours.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            50.sizedBoxH,
            Text(Ids.phone_register.str(),style: TextStyle(color: Colours.black,fontSize: 36.sp),),
            50.sizedBoxH,
          _buildAvatar(context),
            50.sizedBoxH,
          _buildOperateLayout(Ids.nickname.str(),_buildTextField(Ids.nickname_example,controller.nicknameController,inputType: TextInputType.name)),
          _buildOperateLayout(Ids.country_and_area.str(),TapWidget(onTap: () async {
            var zoneCode =  await NavigatorUtils.toNamed(ZoneCodePage.routeName);
            if(zoneCode != null){
              controller.changeZoneCode(zoneCode);
            }
          },
          child: Text('${controller.currZone.name}''(+${controller.currZone.tel})',style: TextStyle(color: Colours.black,fontSize: 32.sp),))),
          _buildOperateLayout(Ids.phone.str(),_buildTextField(Ids.phone_input_hint,controller.phoneController,inputType: TextInputType.phone)),
          _buildOperateLayout(Ids.password.str(),_buildTextField(Ids.input_password,controller.passwordController,inputType: TextInputType.name)),
          100.sizedBoxH,
          _buildPrivacy(),
          40.sizedBoxH,
          _builcConfirmBtn()
        ],
      ),
    );
  }

  _buildTextField(String hint,TextEditingController controller,{TextInputType? inputType}){
    return TextField(
      style: TextStyle(color: Colours.black,fontSize: 32.sp),
      decoration:  InputDecoration(
        hintText: hint.str(),
        hintStyle: TextStyle(color: Colours.c_999999,fontSize: 32.sp),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
        border: const UnderlineInputBorder(borderSide: BorderSide.none),
      ),
      keyboardType: inputType,
      controller: controller,
    );
  }

  _buildAvatar(BuildContext context){
    return TapWidget(
      onTap: () async {
        var file = await DialogUtil.choosePhotoDialog(context,crop: true);
        if(file != null){
          controller.changeAvatar(file);
        }
      },
      child: (controller.avatar == null)? Image.asset(
        Utils.getImgPath('select_avatar',dir: 'avatar',format: Utils.WEBP),
        width: 150.w,
        height: 150.w,
      ):Image.file(controller.avatar!,width: 150.w,height: 150.w,fit:BoxFit.fill,),
    );
  }

  _buildOperateLayout(String hint , Widget operate){
    return Container(
      height: 100.w,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.w, color: Colours.c_999999.withOpacity(0.3)))
      ),
      child: Row(
        children: [
          20.sizedBoxW,
          SizedBox(
              width: 180.w,
              child: Text(hint,style: TextStyle(color: Colours.black,fontSize: 32.sp),)),
          Expanded(child: operate),
        ],
      ),
    );
  }

  _buildPrivacy(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TapWidget(onTap: () {
          controller.changePrivacy();
        },
        child: Container(
            margin: EdgeInsets.only(top: 5.w),
            child: Image.asset(Utils.getImgPath(controller.checkPrivacy?'checkbox_actived':'checkbox_normal',dir: 'icon'),width: 30.w,height: 30.w,))),
        10.sizedBoxW,
        Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(text:Ids.software_licensing_and_services_ordinance_1.str(),style: TextStyle(color: Colours.c_666666,fontSize: 28.sp)),
              TextSpan(text:Ids.software_licensing_and_services_ordinance_2.str(),style: TextStyle(color: Colours.c_0066FF,fontSize: 28.sp),recognizer: TapGestureRecognizer()..onTap = (){
                  NavigatorUtils.toNamed(WebViewPage.routeName,arguments: WebviewArguments(title:Ids.software_licensing_and_services_ordinance_2.str(),url:Constant.SOFTWARE_LICENSING));
              }),
              TextSpan(text:Ids.software_licensing_and_services_ordinance_3.str(),style: TextStyle(color: Colours.c_666666,fontSize: 28.sp)),
            ],
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  _builcConfirmBtn(){
    bool enable = controller.registerEnable;
    return CommonBtn(text: Ids.agree_and_continue.str(), onTap: (){
      if(enable){
        controller.verifyDevice();
      }
    },textStyle: TextStyle(color: enable?Colours.white:Colours.c_999999,fontSize: 32.sp),
    backgroundColor: enable?Colours.theme_color:Colours.c_EEEEEE, height: 80.w, width: 300.w,);
  }

}
