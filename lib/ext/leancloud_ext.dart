
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/controller/member_controller.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';

import '../language/strings.dart';

extension LcUserExt on LCObject {

   String? get avatar{
     String? avatar = this['avatar'];
    return avatar;
  }

   String? get nickname{
     String? nickname = this['nickname'];
     return nickname;
   }

   String? get wxId{
     String? wxId = this['wx_id'];
     return wxId;
   }

}

extension LcConversationExt on Conversation {

  ///是否单聊
  bool get isSingle {
    return isUnique;
  }

  ///聊天标题
  String title({bool showMember = false}){
    if(isSingle){
      String? title;
      members?.forEach((username) {
        if(username != UserController.instance.username){
          title = MemberController.instance.getMember(username)?.nickname;
        }
      });
      return title??'title';
    }else{
      return name != null ?(showMember?name!+'(${members?.length??0})':name!):'title';
    }
  }

}

extension LCMessageExt on Message{

  String get contentText{
    if(this is TextMessage){
      return (this as TextMessage).text??'';
    }
    if(this is ImageMessage){
      return Ids.item_image.str();
    }
    if(this is AudioMessage){
      return Ids.item_audio.str();
    }
    if(this is VideoMessage){
      return Ids.item_video.str();
    }
    if(this is FileMessage){
      return Ids.item_file.str();
    }
    if(this is LocationMessage){
      return Ids.item_location.str();
    }
    return '';
  }

}