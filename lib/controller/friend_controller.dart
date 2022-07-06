import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:lpinyin/lpinyin.dart';

class FriendController extends BaseXController{

  FriendController._();

  FriendController.create();

  static FriendController get instance => Get.find();

  static const List<String> tags = ['⬆️','a','b','c','d','e','f','g','h','i','j','k','l','n','m','o','p','q','r','s','p','u','v','w','x','y','z'];
  RxList<LCObject> friends = <LCObject>[].obs;


  friendIndex(){
    lcPost(() async {
      LCQuery<LCObject> query = UserController.instance.user!.followeeQuery().whereEqualTo('friendStatus', true);
      List<LCObject>? result = await query.find();
      friends.clear();
      if(result?.isNotEmpty??false){
        friends.addAll(result!);
        for (var element in friends) {
          String pinyin = PinyinHelper.getPinyinE(element['followee']['nickname']).substring(0, 1).toUpperCase();
          element['pinyin'] = pinyin;
        }
        friends.sort((o,o1){
          return o['pinyin'].compareTo(o1['pinyin']);
        });
      }
    },showloading: false,showToast: false,);
  }

  isFriend(String username){
    return friends.indexWhere((element) => element['followee']['username']==username) != -1;
  }


}