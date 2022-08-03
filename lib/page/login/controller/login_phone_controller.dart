
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/language/strings.dart';
import 'package:wechat/utils/navigator_utils.dart';

import '../../main/main_page.dart';
import '../login_phone_page.dart';
import '../model/zone_code.dart';

class LoginPhoneController extends BaseXController{

  TextEditingController passwordController = TextEditingController(text: '18202003769');
  String phone = Get.arguments;

  @override
  onInit(){
    super.onInit();
    passwordController.addListener(() {
      update();
    });
  }


  login() async {
    lcPost(() async {
     var bool = await UserController.instance.login(phone, passwordController.text.toString());
     if(bool){
       NavigatorUtils.offAllNamed(MainPage.routeName);
     }
    });

  }


}