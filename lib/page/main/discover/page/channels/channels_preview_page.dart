import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/page/main/discover/page/channels/widget/channels_item_widget.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/status_bar_padding_layout.dart';
import 'package:wechat/core.dart';

import '../../../../../widget/navigator_back_icon.dart';

class ChannelsPreviewPage extends StatefulWidget {

  static const String routeName = '/ChannelsPreviewPage';

  const ChannelsPreviewPage({Key? key}) : super(key: key);

  @override
  State<ChannelsPreviewPage> createState() => _ChannelsPreviewPageState();
}

class _ChannelsPreviewPageState extends State<ChannelsPreviewPage> {

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      showAppbar: false,
      body:Stack(
      children: [
        ChannelItemWidget(channel: Get.arguments,),
        StatusBarPaddingLayout(child: Container(
          padding: EdgeInsets.only(left: 20.w,top: 20.w),
          child: NavigatorBackIcon(),
        ))
      ],
    ));
  }

}
