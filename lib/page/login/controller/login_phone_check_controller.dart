
import 'package:flutter/cupertino.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/core.dart';
import 'package:wechat/language/strings.dart';
import 'package:wechat/utils/navigator_utils.dart';

import '../login_phone_page.dart';
import '../model/zone_code.dart';

class LoginPhoneCheckController extends BaseXController{

  ZoneCode currZone = ZoneCode(short: 'CN',name: '中国大陆',en: 'China',tel: '86', pinyin: 'zgdl');

  TextEditingController phoneController = TextEditingController();

  @override
  onInit(){
    phoneController.addListener(() {
      update();
    });
  }

  void changeZoneCode(ZoneCode zoneCode) {
    currZone = zoneCode;
    update();
  }

  checkPhone() async {
    lcPost(() async {
      var query = LCUser.getQuery();
      String phone = "+" + currZone.tel! + phoneController.text;
      query.whereEqualTo('mobilePhoneNumber', phone);
      var first = await query.first();
      if (first != null) {
        NavigatorUtils.offNamed(LoginPhonePage.routeName,arguments: phone);
      }else{
        Ids.user_no_exist.str().toast();
      }
    });

  }


}