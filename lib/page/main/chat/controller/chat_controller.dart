import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/controller/chat_manager_controller.dart';

import '../widget/press_record_widget.dart';

class ChatController extends BaseXController {

  late String chatId;
  Conversation? conversation;
  RxBool startAudioRecord = false.obs;
  RxInt recordStatus = PressRecordWidgetState.VOICE_STATUS_START.obs;
  RxInt inputLength = 0.obs;
  final TextEditingController textController = TextEditingController();

  final ChatManagerController _managerController = ChatManagerController.instance;

  @override
  void onReady() {
    super.onReady();
    chatId = Get.arguments;
    _initListener();
    initConversation();
  }

  _initListener(){
    textController.addListener(() {
      inputLength.value = textController.text.trim().length;
    });
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

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

}