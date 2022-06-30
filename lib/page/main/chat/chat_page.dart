import 'package:flutter/cupertino.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/chat/controller/chat_controller.dart';
import 'package:wechat/widget/base_scaffold.dart';

class ChatPage extends BaseGetBuilder<ChatController>{

  static const String routeName = '/ChatPage';

  @override
  Widget controllerBuilder(BuildContext context, ChatController controller){
    return MyScaffold(
        title: controller.conversation?.title(showMember: true)??'',
    );
  }

  @override
  ChatController? getController() => ChatController();

}