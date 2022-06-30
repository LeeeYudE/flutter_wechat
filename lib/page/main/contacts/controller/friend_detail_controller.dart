import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/controller/chat_manager_controller.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/navigator_utils.dart';

import '../../../../controller/friend_controller.dart';
import '../../../../language/strings.dart';
import '../friend_detail_page.dart';

class FriendDetailController extends BaseXController {

  late String username;
  LCUser? friend;
  bool isFriend = false;


  @override
  void onReady() {
    super.onReady();
    username = Get.arguments??'';
    if(TextUtil.isEmpty(username)){
      NavigatorUtils.pop();
      return;
    }
    friendDetail();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void friendDetail() async {
      lcPost(() async {
        LCQuery<LCUser> userQueryPhone = LCUser.getQuery();
        userQueryPhone.whereEqualTo('username', username);
        List<LCUser?>? results = await userQueryPhone.find();
        if(results?.isNotEmpty??false){
          friend = results!.first;
          isFriend = FriendController.instance.isFriend(username);
        }
      },changeState: true,showloading: false);
  }

  void addContacts(){
    lcPost(() async {
      await LCFriendship.request(friend?.objectId??'');
      Ids.send_success.str().toast();
      NavigatorUtils.pop(true);
    });
  }

}