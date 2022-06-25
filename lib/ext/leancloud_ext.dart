
import 'package:leancloud_storage/leancloud.dart';

extension LcUserExt on LCUser {

   String? get avatar{
     String? avatar = this['avatar'];
    return avatar;
  }

}