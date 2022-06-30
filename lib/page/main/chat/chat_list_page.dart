import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/chat/widget/chat_item.dart';
import 'package:wechat/widget/remove_top_widget.dart';

import '../../../base/base_view.dart';
import '../../../controller/chat_manager_controller.dart';
import '../../../language/strings.dart';
import '../widget/main_appbar.dart';


class ChatListPage extends StatefulWidget {

  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

  final ChatManagerController _controller = ChatManagerController.instance;


  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        Ids.wachat.str(),
        _buildBody(_controller)
    );
  }

  _buildBody(ChatManagerController controller) {
    return Obx(()=> Container(
        color: Colours.white,
        child: RemoveTopPaddingWidget(child: ListView.builder(itemBuilder: (context,index){
          var chat = controller.chatList[index];
          return ChatItem(conversation: chat,);
        },itemCount: controller.chatList.length,)),
      ),
    );
  }


}
