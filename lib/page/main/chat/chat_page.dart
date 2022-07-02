import 'package:flutter/cupertino.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/chat/controller/chat_controller.dart';
import 'package:wechat/page/main/chat/widget/chat_input_widget.dart';
import 'package:wechat/page/main/chat/widget/record_preview%20_widget.dart';
import 'package:wechat/widget/base_scaffold.dart';

import '../../../color/colors.dart';
import '../../../utils/utils.dart';
import '../../../widget/tap_widget.dart';

class ChatPage extends BaseGetBuilder<ChatController>{

  static const String routeName = '/ChatPage';

  @override
  Widget controllerBuilder(BuildContext context, ChatController controller){
    return MyScaffold(
        title: controller.conversation?.title(showMember: true)??'',
        body: _buildBody(context),
      actions: [
        TapWidget(onTap: () async {

        }, child: Image.asset(Utils.getImgPath('ic_more_black',dir: Utils.DIR_ICON,),width: 40.w,height: 40.w,))
      ],
    );
  }

  @override
  ChatController? getController() => ChatController();

  _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildContent(),
        const ChatInputWidget(),
      ],
    );
  }

  _buildContent(){
    return Expanded(child: Stack(
      children: [
        Container(color: Colours.c_EEEEEE,),
        RecordPreviewWidget()
      ],
    ));
  }

}