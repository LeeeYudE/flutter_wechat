import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/widget/base_scaffold.dart';

import '../widget/main_appbar.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      showLeading: false,
      title: '微信',
      appbarColor: Colours.c_EEEEEE,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      color: Colours.theme_color,
    );
  }
}
