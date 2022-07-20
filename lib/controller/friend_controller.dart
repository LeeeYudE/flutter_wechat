import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:lpinyin/lpinyin.dart';

import '../utils/md5_utils.dart';

class FriendController extends BaseXController{

  FriendController._();

  FriendController.create();

  static FriendController get instance => Get.find();

  static const List<String> tags = ['*','a','b','c','d','e','f','g','h','i','j','k','l','n','m','o','p','q','r','s','p','u','v','w','x','y','z'];
  RxList<LCObject> friends = <LCObject>[].obs;


  friendIndex(){
    lcPost(() async {
      LCQuery<LCObject> query = UserController.instance.user!.followeeQuery().whereEqualTo('friendStatus', true);
      List<LCObject>? result = await query.find();
      friends.clear();
      if(result?.isNotEmpty??false){
        friends.addAll(result!);
        for (var element in friends) {
          String pinyin = PinyinHelper.getPinyinE(element['followee']['nickname']).substring(0, 1).toLowerCase();
          if(tags.contains(pinyin)){
            element['pinyin'] = pinyin;
          }else{
            element['pinyin'] = '*';
          }
        }
        _sort();
      }
    },showloading: false,showToast: false,);
  }

  _sort(){
    friends.sort((o,o1){
      String pinyin1 = o['pinyin']??'*';
      String pinyin2 = o1['pinyin']??'*';
      if(pinyin1 == '*' && pinyin2 != '*'){
        return -1;
      }
      if(pinyin1 != '*' && pinyin2 == '*'){
        return 1;
      }
      return pinyin1.compareTo(pinyin2);
    });
  }


  test() async {
    int i = 0;
   await Future.forEach<String>(tags, (element) async {
    await lcPost(() async {
       i++;
       LCUser user = LCUser();
       String phone = "+86182000000" "${i < 10?'0':''}$i";
       print('phone $phone');
       user.username = phone;
       user.password = 'Bb123456';
       user.mobile = phone;
       user['nickname'] = element.toUpperCase()+element;
       user['wxid_'] = Md5Util.createWxId;
       await user.signUp();
       await LCFriendship.request('62d674b2ec2aee145d798665');
       await LCUser.logout();
     },showloading: false,showToast: false);

    });
  }

  isFriend(String username){
    return friends.indexWhere((element) => element['followee']['username']==username) != -1;
  }


}