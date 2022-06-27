import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/utils/utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../language/strings.dart';
import '../widget/main_appbar.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

  List<String> menuItems = [];

  final CustomPopupMenuController _controller = CustomPopupMenuController();



  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      Ids.wachat.str(),
      _buildBody()
    );
  }

  _buildBody() {
    return Container(
      color: Colours.white,
    );
  }
}
