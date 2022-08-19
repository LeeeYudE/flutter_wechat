
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/controller/member_controller.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/chat/model/red_packet_message.dart';

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
     String? wxId = this['wxid'];
     return wxId;
   }

   double get balance{
     var balance = this['balance'];
     return balance != null ? double.parse(balance.toString()):0.0;
   }

   String? get friendCircilBg{
     return this['friendCircilBg'];
   }

   updateBalance(double balance){
     this['balance'] = balance;
     save();
   }

}

extension LcConversationExt on Conversation {

  ///是否单聊
  bool get isSingle {
    return isUnique;
  }

  ///是否群聊
  bool get isGroup {
    return !isUnique;
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

  bool get isPin => attributes?['pin']??false;

  List<String> get membersStr => members?.map<String>((e) => e.toString()).toList()??[];

}

extension LCMessageExt on Message{

  static const int TYPE_TEXT = 1;
  static const int TYPE_IMAGE = 2;
  static const int TYPE_AUDIO = 3;
  static const int TYPE_VIDEO = 4;
  static const int TYPE_FILE = 5;
  static const int TYPE_LOCATION = 6;
  static const int TYPE_RED_PACKET= 7;

  bool get isSend => fromClientID == UserController.instance.username;


  int get messageType {
    if(this is TextMessage){
      return TYPE_TEXT;
    }
    if(this is ImageMessage){
      return TYPE_IMAGE;
    }
    if(this is AudioMessage){
      return TYPE_AUDIO;
    }
    if(this is VideoMessage){
      return TYPE_VIDEO;
    }
    if(this is FileMessage){
      return TYPE_FILE;
    }
    if(this is LocationMessage){
      return TYPE_LOCATION;
    }
    if(this is RedPacketMessage){
      return TYPE_RED_PACKET;
    }
    return -1;
  }

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
    if(this is RedPacketMessage){
      return Ids.item_red_packet.str() + ((this as RedPacketMessage).text??'');

    }
    return '';
  }


}

extension TypeMessageExt on TypedMessage{

  Map get metaData{
    var _lcfile = rawData['_lcfile'];
    if(_lcfile == null){
      rawData['_lcfile'] = {};
    }
    var metaData = rawData['_lcfile']['metaData'];
    if(metaData == null){
      metaData = {};
      rawData['_lcfile']['metaData'] = metaData;
    }
    return metaData;
  }

  String get filename {
    String? _filename;
    final Map? metaDataMap = metaData;
    if (metaDataMap != null) {
      _filename = metaDataMap['filename']?.toString();
    }
    return _filename??'';
  }

  String get fileSize {
    String? _filename;
    final Map? metaDataMap = metaData;
    if (metaDataMap != null) {
      _filename = metaDataMap['size']?.toString();
    }
    return _filename??'';
  }

}

extension LocationMessageExt on LocationMessage{

  String get addressUrl {
    return 'http://api.map.baidu.com/staticimage?center=$longitude,$latitude&maker=$longitude,$latitude&width=${400.w}&height=${150.w}&zoom=14';
  }

}

extension VideoMessageExt on VideoMessage{

  double get thumbnailWidth {
    double? _thumbnailWidth;
    final Map? metaDataMap = metaData;
    if (metaDataMap != null) {
      _thumbnailWidth = metaDataMap['_thumbnailWidth'];
    }
    return _thumbnailWidth??0.0;
  }

  double get thumbnailHeight {
    double? _thumbnailHeight;
    final Map? metaDataMap = metaData;
    if (metaDataMap != null) {
      _thumbnailHeight = metaDataMap['thumbnailHeight']?.toDouble();
    }
    return _thumbnailHeight??0.0;
  }

  String? get thumbnailUrl {
    String? _thumbnailHeight;
    final Map? metaDataMap = metaData;
    if (metaDataMap != null) {
      _thumbnailHeight = metaDataMap['thumbnailUrl'];
    }
    return _thumbnailHeight;
  }

}