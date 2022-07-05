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
    
  }

  initConversation(){
    conversation = _managerController.getChatInfo(chatId);
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
    _sendMessage(textMessage);
  }

  sendImage(String path) async {
    var imageMessage = ImageMessage.from(path: path,);
    _sendMessage(imageMessage);
  }

  sendAudio(String path){
    var imageMessage = AudioMessage.from(path: path,);
    _sendMessage(imageMessage);
  }

  sendVideo(String path){
    var imageMessage = VideoMessage.from(path: path);
    _sendMessage(imageMessage);
  }

  sendLocation(BMFPoiInfo poi){
    var locationMessage = LocationMessage.from(latitude: poi.pt!.latitude, longitude:  poi.pt!.longitude);
    _sendMessage(locationMessage);
  }

  _sendMessage(Message message){
    if(conversation != null){
      lcPost(() async {
        var sendMessage = await _managerController.sendMessage(conversation!, message);
        _insertMessage(sendMessage);
      },showloading: false,onError: (e){
        _insertMessage(message);
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
    super.onClose();
  }

}