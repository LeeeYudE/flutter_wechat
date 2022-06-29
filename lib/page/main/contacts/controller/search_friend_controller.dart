import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/navigator_utils.dart';

import '../../../../language/strings.dart';
import '../friend_detail_page.dart';

class SearchFriendController extends BaseXController {

  final TextEditingController controller = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    controller.addListener(() {
      update();
    });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void search() async {
    var string = controller.text.trim().toString();
    if(!TextUtil.isEmpty(string))  {
      lcPost(() async {
        LCQuery<LCUser> userQueryPhone = LCUser.getQuery();
        userQueryPhone.whereGreaterThanOrEqualTo('username', string);

        LCQuery<LCUser> userQueryId = LCUser.getQuery();
        userQueryId.whereEqualTo('wx_id', string);

        LCQuery<LCObject> priorityOneOrTwo = LCQuery.or([userQueryPhone, userQueryId]);
        priorityOneOrTwo.limit(1);
        List<LCObject?>? results = await priorityOneOrTwo.find();
        if(results?.isNotEmpty??false){
         var result =  await NavigatorUtils.toNamed(FriendDetailPage.routeName,arguments:results!.first!['username'] );
         if(result??false){
           NavigatorUtils.pop(true);
         }
        }else{
          Ids.user_no_exist.str().toast();
        }
      });
    }
  }

}