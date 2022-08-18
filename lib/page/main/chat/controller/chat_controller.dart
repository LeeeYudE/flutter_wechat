import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:get/get.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/controller/auido_manager.dart';
import 'package:wechat/controller/chat_manager_controller.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../widget/press_record_widget.dart';
import 'package:wechat/core.dart';

class ChatController extends BaseXController {

  late String chatId;
  Conversation? conversation;
  RxBool startAudioRecord = false.obs;
  RxInt recordStatus = PressRecordWidgetState.VOICE_STATUS_START.obs;
  RxList<Message> messages = <Message>[].obs;
  final TextEditingController textController = TextEditingController();
  final AutoScrollController listScrollerController = AutoScrollController(keepScrollOffset: false);
  final ChatManagerController _managerController = ChatManagerController.instance;

  @override
  void onInit() {
    super.onInit();
    chatId = Get.arguments;
    _initListener();
  }

  @override
  void onReady() {
    super.onReady();
    initConversation();
  }

  _initListener(){
    _managerController.addOnMessageReceive(_onMessageReceive);
  }

  _onMessageReceive(Message message){
    if(message.conversationID == conversation?.id){
      _insertMessage(message);
    }
  }

  initConversation() async {
    conversation = _managerController.getChatInfo(chatId);
    _managerController.setCurrentConversation(conversation);
    update();
    refreshMessage();
  }

  refreshMessage(){
    if(conversation != null){
      lcPost(() async {
        List<Message> _messages = await conversation!.queryMessage(
          startMessageID: messages.safetyItem(messages.length-1)?.id,
          startTimestamp: messages.safetyItem(messages.length-1)?.sentTimestamp,
          startClosed: messages.isNotEmpty?false:null,
          limit: Constant.PAGE_SIZE,
        );
        messages.addAll(_messages.reversed);
        debugPrint('messages ${_messages.length}');
      },onError: (Exception e){

      },showloading: false);
    }
  }

  sendText(String content){
    TextMessage textMessage = TextMessage();
    textMessage.text = content;
    sendMessage(textMessage);
  }

  sendImage(File file) async {
    lcPost(() async {
      var lcFile = await LCFile.fromPath(file.filename, file.path);
      await lcFile.save();
      var imageMessage = ImageMessage.from(
          url: lcFile.url,
          format: file.suffix,
          name: file.filename
      );
      sendMessage(imageMessage);
    },showloading: false);
  }

  sendAudio(String path){
    lcPost(() async {
      var file = File(path);
      var lcFile = await LCFile.fromPath(file.filename, path);
      await lcFile.save();
      var imageMessage = AudioMessage.from(
          url: lcFile.url,
          format: file.suffix,
          name: file.filename
      );
      sendMessage(imageMessage);
    },showloading: false);

  }

  sendVideo(File file){
    var imageMessage = VideoMessage.from(path: file.path);
    sendMessage(imageMessage);
  }

  sendLocation(BMFPoiInfo poi){
    var locationMessage = LocationMessage.from(latitude: poi.pt!.latitude, longitude:  poi.pt!.longitude);
    sendMessage(locationMessage);
  }


  sendMessage(Message message){
    if(conversation != null){
      lcPost(() async {
        var sendMessage = await _managerController.sendMessage(conversation!, message);
        _insertMessage(sendMessage);
        AudioManager().sendMessage();
      },showloading: false,onError: (e){
      });
    }
  }

  _insertMessage(Message message){
    messages.insert(0,message);
    listScrollerController.scrollToIndex(0);
  }

  @override
  void onClose() {
    textController.dispose();
    _managerController.removeCurrentConversation();
    _managerController.removeOnMessageReceive(_onMessageReceive);
    super.onClose();
  }

}