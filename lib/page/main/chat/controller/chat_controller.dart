import 'package:flutter/cupertino.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:get/get.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/controller/chat_manager_controller.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../widget/press_record_widget.dart';

class ChatController extends BaseXController {

  static const int PAGE_SIZE = 20;

  late String chatId;
  Conversation? conversation;
  RxBool startAudioRecord = false.obs;
  RxInt recordStatus = PressRecordWidgetState.VOICE_STATUS_START.obs;
  RxList<Message> messages = <Message>[].obs;
  final TextEditingController textController = TextEditingController();
  final AutoScrollController listScrollerController = AutoScrollController(keepScrollOffset: false);
  final ChatManagerController _managerController = ChatManagerController.instance;

  @override
  void onReady() {
    super.onReady();
    chatId = Get.arguments;
    _initListener();
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
    _queryMessage();
  }

  _queryMessage(){
    if(conversation != null){
      lcPost(() async {
        List<Message> messages = await conversation!.queryMessage(
          limit: PAGE_SIZE,
        );
        this.messages.addAll(messages.reversed);
        debugPrint('messages $messages');
      },onError: (Exception e){

      },showloading: false);
    }
  }

  sendText(String content){
    TextMessage textMessage = TextMessage();
    textMessage.text = content;
    sendMessage(textMessage);
  }

  sendImage(String path) async {
    var imageMessage = ImageMessage.from(path: path,);
    sendMessage(imageMessage);
  }

  sendAudio(String path){
    var imageMessage = AudioMessage.from(path: path,);
    sendMessage(imageMessage);
  }

  sendVideo(String path){
    var imageMessage = VideoMessage.from(path: path);
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