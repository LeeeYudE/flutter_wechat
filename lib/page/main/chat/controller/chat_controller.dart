import 'package:flustars/flustars.dart';
import 'package:get/get.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/controller/chat_manager_controller.dart';
import 'package:wechat/core.dart';

class ChatController extends BaseXController {

  late String chatId;
  Conversation? conversation;
  final ChatManagerController _managerController = ChatManagerController.instance;

  @override
  void onReady() {
    super.onReady();
    chatId = Get.arguments;
    initConversation();
  }

  initConversation(){
    conversation = _managerController.getChatInfo(chatId);
    update();
  }

  test(){
    lcPost(() async {
      TextMessage textMessage = TextMessage();
      textMessage.text = 'Jerry，起床了！${DateUtil.getNowDateStr()}';
      await conversation?.send(message: textMessage);
      _managerController.refresh();
    },showloading: false);
  }


}