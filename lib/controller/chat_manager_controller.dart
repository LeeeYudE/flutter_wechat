import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/controller/member_controller.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/chat/chat_page.dart';
import 'package:wechat/page/main/main_page.dart';

import '../utils/navigator_utils.dart';

class ChatManagerController extends BaseXController {

  ChatManagerController._();

  ChatManagerController.create();

 static ChatManagerController get instance => Get.find();

  RxList<Conversation> chatList = <Conversation>[].obs;
  late Client imClient;

  initClient() async {
    imClient = Client(id: UserController.instance.username);
    await imClient.open();
    imClient.onMessage = onMessage;
    imClient.onMessageUpdated = onMessageUpdated;
    imClient.onMessageDelivered = onMessageDelivered;
    chatIndex();

  }

 void onMessageDelivered({required Client client, required Conversation conversation, String? messageID, String? toClientID, DateTime? atDate,}){
   debugPrint('onMessageDelivered ${conversation.lastMessage?.contentText} ${messageID}');
 }

 void onMessageUpdated({required Client client, required Conversation conversation, required Message updatedMessage, int? patchCode, String? patchReason,}){
   debugPrint('onMessageUpdated ${conversation.lastMessage?.contentText} ${updatedMessage.contentText}');
 }

 void onMessage({required Client client,required Conversation conversation,required Message message}){
    debugPrint('onMessage ${conversation.lastMessage?.contentText} ${message.contentText}');
 }

  chatIndex() async {
    ConversationQuery query = imClient.conversationQuery();
    query.includeLastMessage = true;
    var list = await query.find();
    await MemberController.instance.queryChatsUser(list);
    chatList.addAll(list);
    debugPrint('chatIndex ${list.length}');
  }

  createSingleChat(String membersId){
    var chat = getSingleChatInfoOfUsername(membersId);
    if(chat != null){
      NavigatorUtils.offNamedUntil(ChatPage.routeName,MainPage.routeName,arguments: chat.id);
    }else{
      lcPost(() async {
        Conversation conversation = await imClient.createConversation(isUnique: true, members: {membersId}, name: 'test');
        if(!(_chatExist(conversation.id))){
          chatList.add(conversation);
        }
        NavigatorUtils.offNamedUntil(ChatPage.routeName,MainPage.routeName,arguments: conversation.id);
      });
    }

  }

 Conversation? getChatInfo(String id){
    var indexWhere = chatList.indexWhere((element) => element.id == id);
    if(indexWhere != -1){
      return chatList[indexWhere];
    }
    return null;
  }

  Conversation? getSingleChatInfoOfUsername(String username){
    var indexWhere = chatList.indexWhere((element) => element.isSingle && (element.members?.contains(username)??false) && (element.members?.contains(UserController.instance.username)??false));
    if(indexWhere != -1){
      return chatList[indexWhere];
    }
    return null;
  }

  _chatExist(String id){
    return chatList.value.hasIndex((element) => element.id == id);
  }

  refresh(){
    chatList.refresh();
  }

}