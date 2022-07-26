import 'package:get/get.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';


///聊天成员管理类，暂不支持获取群内成员列表，所以需要自己维护成员信息
class MemberController extends BaseXController {

  MemberController._();

  MemberController.create();

  static MemberController get instance => Get.find();

  Map<String,LCUser> members = {};

  updateMyUser(){
    queryUser(UserController.instance.username,update: true);
  }

  Future<LCUser?> queryUser(String? username,{bool update = false}) async {
    LCUser? result;
    if(update || (!members.containsKey(username) && !TextUtil.isEmpty(username))){
     await lcPost(() async {
        LCQuery<LCUser> userQueryPhone = LCUser.getQuery();
        userQueryPhone.whereEqualTo('username', username);
        result = await userQueryPhone.first();
        if(result != null){
          _putMember(result!);
        }
      },showloading: false,showToast: false);
    }
    return result;
  }

  queryChatsUser(List<Conversation> cons) async {
    await lcPost(() async {
      List<LCQuery<LCUser>> querys = [];
      for (var element in cons) {
        element.members?.forEach((username) {
          if(!members.containsKey(username)){
            querys.add(LCUser.getQuery().whereEqualTo('username', username));
          }
        });
      }
      if(querys.isNotEmpty){
        List<LCUser>? results = await LCQuery.or(querys).find();
        results?.forEach((element) {
          _putMember(element);
        });
      }
    },showloading: false,showToast: false);
  }

  _putMember(LCUser user){
    members[user.username!] = user;
  }

  LCUser? getMember(String? username){
    if(members.containsKey(username)){
      return members[username];
    }
    queryUser(username);
    return null;
  }

}