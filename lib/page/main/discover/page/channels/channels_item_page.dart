import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/page/main/discover/page/channels/widget/channels_item_widget.dart';

import 'controller/channels_controller.dart';

class ChannelsItemPage extends StatefulWidget {

  static const String tagFollow = 'tagFollow';///关注
  static const String tagFriend = 'tagFriend';///好友
  static const String tagRecommend = 'tagRecommend';///推荐

  String tag;

  ChannelsItemPage({required this.tag,Key? key}) : super(key: key);

  @override
  State<ChannelsItemPage> createState() => _ChannelsItemPageState();
}

class _ChannelsItemPageState extends State<ChannelsItemPage> with AutomaticKeepAliveClientMixin , SingleTickerProviderStateMixin {

  late ChannelsController controller;

  @override
  void initState() {
    controller = Get.put(ChannelsController(),tag: widget.tag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(()=> EasyRefresh(
      onRefresh: () async {
        await controller.queryChannles(refresh: true);
      },
      onLoad: () async {
        controller.queryChannles(refresh: false);
      },
      header: const MaterialHeader(),
      footer: const ClassicFooter(),
      child: PageView.builder(itemBuilder: (context , index){
        return ChannelItemWidget(channel: controller.list[index],channelsController: controller,);
      },scrollDirection:Axis.vertical,itemCount: controller.list.length,controller: controller.pageController,),
    ),
    );
  }


  @override
  bool get wantKeepAlive => true;



}
