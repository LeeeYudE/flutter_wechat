import 'dart:collection';

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

import '../language/strings.dart';
import '../utils/navigator_utils.dart';

class ChatManagerController extends BaseXController {

  ChatManagerController._();

  ChatManagerController.create();

 static ChatManagerController get instance => Get.find();

  RxList<Conversation> chatList = <Conversation>[].obs;
  List<ValueChanged<Message>> onMessageReceive = [];
  Conversation? _currentConversation;
  late Client imClient;

  initClient() async {
    imClient = Client(id: UserController.instance.username);
    await imClient.open();
    imClient.onMessage = _onMessage;
    imClient.onMessageUpdated = _onMessageUpdated;
    imClient.onMessageDelivered = _onMessageDelivered;
    imClient.onMessageRead = _onMessageRead;
    imClient.onUnreadMessageCountUpdated = _onUnreadMessageCountUpdated;
    chatIndex();
  }

  removeCurrentConversation(){
    _currentConversation = null;
  }

  setCurrentConversation(Conversation? conversation){
    _currentConversation = conversation;
    _currentConversation?.read();
  }

  void addOnMessageReceive(ValueChanged<Message> callback){
    onMessageReceive.add(callback);
  }

  void removeOnMessageReceive(ValueChanged<Message> callback){
    onMessageReceive.remove(callback);
  }

  void _onUnreadMessageCountUpdated({required Client client, required Conversation conversation,}){
    debugPrint('_onUnreadMessageCountUpdated ${conversation.unreadMessageCount}');
    _updateConversation(conversation);
  }

  void _onMessageRead({required Client client, required Conversation conversation, String? messageID, String? byClientID, DateTime? atDate,}){
    debugPrint('onMessageRead ${conversation.unreadMessageCount} ${messageID}');
  }

 void _onMessageDelivered({required Client client, required Conversation conversation, String? messageID, String? toClientID, DateTime? atDate,}){
   debugPrint('onMessageDelivered ${conversation.lastMessage?.contentText} ${messageID}');
 }

 void _onMessageUpdated({required Client client, required Conversation conversation, required Message updatedMessage, int? patchCode, String? patchReason,}){
   debugPrint('onMessageUpdated ${conversation.lastMessage?.contentText} ${updatedMessage.contentText}');
 }

 void _onMessage({required Client client,required Conversation conversation,required Message message}) async {
    debugPrint('onMessage ${conversation.unreadMessageCount} ${message.contentText}');
    await MemberController.instance.queryUser(message.fromClientID??'');
    for (var element in onMessageReceive) {
      element.call(message);
    }
    if(_currentConversation != null && _currentConversation?.id == conversation.id){
      conversation.read();
    }
    _updateConversation(conversation);
 }

 _updateConversation(Conversation conversation){
   var indexWhere = chatList.indexWhere((element) => element.id == conversation.id);
   if(indexWhere != -1){
     chatList[indexWhere] = conversation;
   }else{
     chatList.add(conversation);
   }

 }

  chatIndex() async {
    ConversationQuery query = imClient.conversationQuery();
    query.includeLastMessage = true;
    var list = await query.find();
    await MemberController.instance.queryChatsUser(list);
    chatList.clear();
    chatList.addAll(list);
    _sortChat();
    debugPrint('chatIndex ${list.length}');
  }

  _sortChat(){
    chatList.sort((c1,c2){
      if(c1.isPin && !c2.isPin){
        return -1;
      }
      if(!c1.isPin && c2.isPin){
        return 1;
      }
      return (c1.lastMessageTimestamp??0) > (c2.lastMessageTimestamp??0) ? -1 : 1;
    });
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

  Future<Message> sendMessage(Conversation conversation , Message message) async {
    Message _message = await conversation.send(message: message);
    _refresh(sort: true);
    return _message;
  }

  createConversation(List<LCObject> members) async {
    lcPost(() async {
      HashSet<String> _member = HashSet();
      for (var element in members) {
        _member.add(element['followee']['username']);
      }
      Conversation _c =  await imClient.createConversation(members: _member,name:Ids.group_chat.str(),isUnique: false);
      _updateConversation(_c);
      NavigatorUtils.toNamed(ChatPage.routeName,arguments: _c.id);
    });

  }

  _chatExist(String id){
    return chatList.hasIndex((element) => element.id == id);
  }

  _refresh({bool sort = false}){
    if(sort){
      _sortChat();
    }
    chatList.refresh();
  }

  _removeChat(Conversation conversation){
    chatList.remove(conversation);
    _refresh();
  }

  deleteChat(Conversation conversation) async {
    lcPost(() async {
      // await conversation.quit();
      _removeChat(conversation);
    });

  }

  updatePin(Conversation conversation,bool pin){
    lcPost(() async {
      await conversation.updateInfo(attributes: {'pin':pin});
      _refresh(sort: true);
    });
  }


  void logout() {
    imClient.close();
  }

}