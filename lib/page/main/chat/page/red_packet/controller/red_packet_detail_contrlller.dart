
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/base/constant.dart';

import '../../../model/red_packet_message.dart';

class RedPacketDetailController extends BaseXController{

  late RedPacketMessage message;
  LCObject? redPacket;

  @override
  void onInit() {
    super.onInit();
    message = Get.arguments;
  }

  @override
  void onReady() {
    super.onReady();
    lcPost(() async {
      var lcQuery = LCQuery(Constant.OBJECT_NAME_RED_PACKET);
      lcQuery.whereEqualTo('objectId', message.rawData['redPacketId']);
      redPacket = await lcQuery.first();
    },showloading: false);
  }

}