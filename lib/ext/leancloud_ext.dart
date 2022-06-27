
import 'package:leancloud_storage/leancloud.dart';

extension LcUserExt on LCUser {

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