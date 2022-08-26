import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:get/get.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:video_compress/video_compress.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/controller/auido_manager.dart';
import 'package:wechat/controller/chat_manager_controller.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:wechat/utils/video_util.dart';
import '../../../../utils/image_util.dart';
import '../widget/press_record_widget.dart';
import 'package:wechat/core.dart';

class ChatController extends BaseXController {

  late String chatId;
  Conversation? conversation;
  RxBool startAudioRecord = false.obs;
  RxInt recordStatus = PressRecordWidgetState.VOICE_STATUS_START.obs;
  RxInt peakPower = 1.obs;
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
      _insertMessage(message,scrollTobottom: true);
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
      var compressImage = await ImageUtil.compressImage(file);
      if(compressImage != null){
        var lcFile = await LCFile.fromPath(file.filename, compressImage);
        await lcFile.save();
        var imageMessage = ImageMessage.from(
            url: lcFile.url,
            format: file.suffix,
            name: file.filename
        );
        var imageSize = await ImageUtil.imageSize(file);
        var metaData = imageMessage.metaData;
        metaData['filename'] = file.filename;
        metaData['width'] = imageSize.width;
        metaData['height'] = imageSize.height;

        sendMessage(imageMessage);
      }

    },showloading: true);
  }

  sendAudio(String path, int duration){
    lcPost(() async {
      var file = File(path);
      var lcFile = await LCFile.fromPath(file.filename, path);
      lcFile.metaData = {
        'duration':duration,
      };
      await lcFile.save();
      var audioMessage = AudioMessage.from(
          url: lcFile.url,
          format: file.suffix,
          name: file.filename
      );
      var metaData = audioMessage.metaData;
      metaData['duration'] = duration;
      metaData['filename'] = file.filename;
      sendMessage(audioMessage);
    },showloading: true);

  }

  sendVideo(File file){

    lcPost(() async {

      var videoThumbnail = await VideoUtil.videoThumbnail(file.path);

      var thumbnailLc = await LCFile.fromPath(videoThumbnail.filename, videoThumbnail.path);

      var compressVideo = await VideoUtil.compressVideo(file.path);
      if(compressVideo != null && compressVideo.path != null){

        await thumbnailLc.save();

        var lcVideo = await LCFile.fromPath(file.filename, compressVideo.path!);

        await lcVideo.save();
        var videoMessage = VideoMessage.from(
            url: lcVideo.url,
            format: file.suffix,
            name: file.filename
        );
        var imageSize = await ImageUtil.imageSize(videoThumbnail);
        var metaData = videoMessage.metaData;
        metaData['filename'] = file.filename;
        metaData['duration'] = compressVideo.duration;
        metaData['videoWidth'] = compressVideo.height;
        metaData['videoHeight'] =  compressVideo.width;

        metaData['thumbnailWidth'] = imageSize.width;
        metaData['thumbnailHeight'] =  imageSize.height;
        metaData['thumbnailUrl'] =  thumbnailLc.url;

        sendMessage(videoMessage);
      }
    },showloading: true);

  }

  sendFile(File file) async {
    lcPost(() async {
        var lcFile = await LCFile.fromPath(file.filename, file.path);
        await lcFile.save();
        var imageMessage = FileMessage.from(
            url: lcFile.url,
            format: file.suffix,
            name: file.filename
        );
        var metaData = imageMessage.metaData;
        metaData['filename'] = file.filename;
        metaData['size'] = file.lengthSync();

        sendMessage(imageMessage);

    },showloading: true);
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

  _insertMessage(Message message,{bool scrollTobottom = true}){
    messages.insert(0,message);
    if(scrollTobottom){
      listScrollerController.scrollToIndex(0);
    }
  }

  @override
  void onClose() {
    textController.dispose();
    _managerController.removeCurrentConversation();
    _managerController.removeOnMessageReceive(_onMessageReceive);
    AudioManager().dispose();
    super.onClose();
  }

}