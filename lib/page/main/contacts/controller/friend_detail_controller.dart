import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/controller/chat_manager_controller.dart';
import 'package:wechat/controller/member_controller.dart';
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
  RxList<String> friendCircles = <String>[].obs;


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
        friend = await MemberController.instance.queryUser(username,update: true);
        if(friend != null){
          isFriend = FriendController.instance.isFriend(username);
           var lcQuery = LCQuery(Constant.OBJECT_NAME_FRIEND_CIRCLE);
          lcQuery.whereEqualTo('user', friend);
          lcQuery.whereEqualTo('mediaType', 1);
          lcQuery.limit(10);
          var friendFind = await lcQuery.find();
          List<String> _list = [];
          friendFind?.forEach((element) {
            List<dynamic> photos = element['photos'];
            _list.addAll(photos.map<String>((e) => e['url']).toList());
          });
          friendCircles.addAll(_list);
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