import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/navigator_utils.dart';

import '../../../language/strings.dart';
import '../../../utils/md5_utils.dart';
import '../model/zone_code.dart';
import '../register_success_page.dart';
import '../safety_verify_page.dart';

class RegisterController extends BaseXController{

  ZoneCode currZone = ZoneCode(short: 'CN',name: '中国大陆',en: 'China',tel: '86', pinyin: 'zgdl');

  TextEditingController nicknameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool checkPrivacy = false;
  RxBool checkPrivacyRx = false.obs;
  bool registerEnable = false;

  File? avatar;

  @override
  onInit(){
    nicknameController.addListener(() {
      checkEnable();
    });
    phoneController.addListener(() {
      checkEnable();
    });
    passwordController.addListener(() {
      checkEnable();
    });
  }

  checkEnable(){
    var nickname = nicknameController.text.trim().isNotEmpty;
    var phone = phoneController.text.trim().isNotEmpty;
    var passowrd = passwordController.text.trim().isNotEmpty;
    var privacy = checkPrivacy;

    registerEnable = nickname && phone && passowrd && privacy;
    update();
  }

  changeAvatar(File avatar){
    this.avatar = avatar;
    update();
  }


  changeZoneCode(ZoneCode currZone){
    this.currZone = currZone;
    update();
  }

  changePrivacy(){
    checkPrivacy = !checkPrivacy;
    checkEnable();
  }

  void verifyDevice() async {

    if(passwordController.text.length < 6){
      Ids.passowrd_too_short.str().toast();
      return;
    }

   var result = await NavigatorUtils.toNamed(SafetyVerifyPage.routeName);
   if(result??false){
     var nickname = nicknameController.text.trim();
     var phone = phoneController.text.trim();
     var password = passwordController.text.trim();
      register(phone, password,nickname,avatar);
   }
  }

  void register(String phone , String password,String nickname , File? avatar) async {

    lcPost(() async {
      // JmessageFlutter _jMessage = JMessageManager.jMessage;

      // await _jMessage.userRegister(
      //     username: (currZone.tel! + phone).replaceAll('+', ''),
      //     password: password,
      //   nickname: nickname
      // );
      // phone =  currZone.tel! + phone;
      // if(avatar != null){
      //  await _jMessage.updateMyAvatar(imgPath: avatar.path);
      // }
      // await _jMessage.updateMyInfo(
      //   extras: {
      //     'wxid':Md5Util.createWxId,
      //     'phone':phone,
      //   }
      // );
      // await _jMessage.logout();
      LCUser user = LCUser();
      if(avatar != null){
        LCFile _file = await LCFile.fromPath(avatar.filename, avatar.path);
        await _file.save();
        user['avatar'] = _file.url;
      }
      phone = "+" + currZone.tel! + phone;
      user.username = phone;
      user.password = password;
      user.mobile = phone;
      user['nickname'] = nickname;

      await user.signUp();
      LCUser.logout();
      NavigatorUtils.offNamed(RegisterSuccessPage.routeName);

    },loadingMsg:Ids.registering.str());

  }


}