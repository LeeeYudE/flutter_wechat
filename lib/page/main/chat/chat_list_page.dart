import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/chat/widget/chat_item.dart';
import 'package:wechat/page/main/chat/widget/uniapp_panel.dart';
import 'package:wechat/widget/remove_top_widget.dart';

import '../../../controller/chat_manager_controller.dart';
import '../../../language/strings.dart';
import '../../../widget/listview/panel_scroll_view.dart';
import '../../../widget/sliding_up_panel.dart';
import '../widget/main_appbar.dart';

class ChatListPage extends StatefulWidget {

  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

  final ChatManagerController _controller = ChatManagerController.instance;
  final GlobalKey<SlidingUpPanelState> _panelKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return WillPopScope(
          onWillPop: () async {
            if(_panelController.isPanelClosed){
              _panelController.open();
              return false;
            }
            return true;
          },
          child: SlidingUpPanel(
            key: _panelKey,
            body: _buildUniapp(),
            parallaxEnabled: true,
            parallaxOffset: 1,
            defaultPanelState: PanelState.OPEN,
            maxHeight: constraints.maxHeight,
            controller: _panelController,
            minHeight: 160.w,
            onWillPop: false,
            panel: MainScaffold(
                Ids.wachat.str(),
                _buildBody(_controller)
            ),
          ),
        );
      },
    );
  }

  _buildUniapp(){
    return UniappPanel(panelController: _panelController,);
  }

  _buildBody(ChatManagerController controller) {
    return Obx(()=> Container(
        color: Colours.white,
        child: RemoveTopPaddingWidget(child: PanelListView.builder(itemBuilder: (context,index){
          var chat = controller.chatList[index];
          return ChatItem(conversation: chat,);
        },itemCount: controller.chatList.length,controller: _scrollController, panelKey:_panelKey
        )),
      ),
    );
  }


}
