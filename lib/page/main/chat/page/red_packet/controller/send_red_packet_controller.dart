import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/chat/controller/chat_controller.dart';
import 'package:wechat/utils/navigator_utils.dart';
import '../../../../../../language/strings.dart';
import '../../../model/red_packet_message.dart';
import '../../pay_password/pay_password_page.dart';
import '../send_red_packet_page.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';

class SendRedPacketController extends BaseXController{

  late Conversation conversation;

  TextEditingController amountController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController hintController = TextEditingController();
  RxString warningHint = ''.obs;

  RxBool showKeyboard = false.obs;

  @override
  void onInit() {
    conversation = Get.arguments;
    amountController.addListener(() {
      update();
    });
    countController.addListener(() {
      if(countController.text.isNotEmpty){
        var count = int.parse(countController.text);
        if(count > 100){
          warningHint.value = Ids.red_packet_max_count.str();
        }else{
          warningHint.value = '';
        }
      }
    });
    super.onInit();
  }


  void sendRedPacket() async {
    if(amountController.text.isEmpty){
      Ids.input_amount.str().toast();
      return;
    }
    if(conversation.isGroup){
      if(countController.text.isEmpty){
        Ids.input_count.str().toast();
        return;
      }else if(int.parse(countController.text) < 1){
        Ids.input_count.str().toast();
        return;
      }
    }
    try{
      var balance = UserController.instance.user?.balance??0.0;
      var amount = double.parse(amountController.text);

      if(conversation.isGroup && amount < 0.01 * int.parse(countController.text)){
        Ids.amont_error.str().toast();
        return;
      }

      if(balance < amount){
        Ids.insufficient_balance.str().toast();
        return;
      }

     var result =  await NavigatorUtils.toNamed(PayPasswordPage.routeName,arguments: PayInfoArguments(amount: amountController.text, hint: Ids.red_package.str()));
      if(result != null){
        lcPost(() async {

          var lcObject = LCObject(Constant.OBJECT_NAME_RED_PACKET);
          ///红包金额
          lcObject['amount'] = amount;
          lcObject['gains'] = [];
          ///红包个数
          lcObject['packet_count'] = conversation.isSingle?1:int.parse(countController.text);
          ///红包类型
          lcObject['packet_type'] = conversation.isSingle?0:1;
          lcObject['user_name'] = UserController.instance.username;
          await lcObject.save();
          var redPacketMessage = RedPacketMessage.from(redPacketId: lcObject.objectId!,hint:hintController.text.trim().isEmpty?Ids.red_packet_hint.str():hintController.text.trim() );
          ChatController _chat = Get.find();
          _chat.sendMessage(redPacketMessage);
          UserController.instance.user?.updateBalance(balance - amount);
          UserController.instance.user?.save();
          NavigatorUtils.pop();
        });
      }


    }catch(e){
      debugPrint('$e');
    }
  }

}