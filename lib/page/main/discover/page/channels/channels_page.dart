import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/page/main/discover/page/channels/channels_video_edit_page.dart';
import 'package:wechat/utils/dialog_util.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/core.dart';

import '../../../../../color/colors.dart';
import '../../../../../utils/navigator_utils.dart';
import 'channels_create_page.dart';
import 'channels_item_page.dart';
import 'controller/channels_controller.dart';

class ChannelsPage extends StatefulWidget {

  static const String routeName = '/ChannelsPage';

  const ChannelsPage({Key? key}) : super(key: key);

  @override
  State<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> with AutomaticKeepAliveClientMixin , SingleTickerProviderStateMixin {

   List<String> titles = ['关注','朋友','推荐'];

   late TabController tabController;

   @override
  void initState() {
     tabController = TabController(vsync: this, length: titles.length,initialIndex:titles.length - 1 );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      showAppbar: false,
      backgroundColor: Colours.black,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Stack(
      children: [
        _buildTabView(),
        _buildBar(context),
      ],
    );
  }

  _buildBar(BuildContext context){
    return Container(
      height: 150.w,
      padding: EdgeInsets.only(top: 60.w,left: 20.w,right: 20.w),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.8),Colours.transparent]
          )
      ),
      // padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 80.w),
      child: Stack(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colours.white.withOpacity(0.8),
            ), onPressed: () {
            NavigatorUtils.pop();
          },
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 150.w),
              child: TabBar(
                controller: tabController,
                tabs: titles.map((e) => Tab(text: e,)).toList(),
                unselectedLabelColor: Colours.white.withOpacity(0.8),
                labelColor: Colours.white,
                indicatorColor: Colours.white,
                indicatorSize:TabBarIndicatorSize.label,
                labelStyle: TextStyle(fontSize: 28.sp),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: Colours.white.withOpacity(0.8),
              ), onPressed: () async {
              var file = await DialogUtil.choosePhotoDialog(context,isVideo: true);
              if(file != null){
               var _video = await NavigatorUtils.toNamed(ChannelsVideoEditPage.routeName,arguments: file);
               if(_video != null)  {
                var result = await NavigatorUtils.toNamed(ChannelsCreatePage.routeName,arguments: file);
                if(result??false){
                  ChannelsController? controller;
                  switch(tabController.index){
                    case 0:
                      controller = Get.find<ChannelsController>(tag:ChannelsItemPage.tagFollow);
                      break;
                    case 1:
                      controller = Get.find<ChannelsController>(tag:ChannelsItemPage.tagFriend);
                      break;
                    case 2:
                      controller = Get.find<ChannelsController>(tag:ChannelsItemPage.tagRecommend);
                      break;
                  }
                  controller?.queryChannles(refresh: true);
                }
               }
              }
            },
            ),
          )
        ],
      ),
    );
  }

  _buildTabView(){
    return TabBarView(children:
    [
      ChannelsItemPage(tag: ChannelsItemPage.tagFollow,),
      ChannelsItemPage(tag: ChannelsItemPage.tagFriend),
      ChannelsItemPage(tag: ChannelsItemPage.tagRecommend),
    ],
      controller: tabController,
    );
  }

  @override
  bool get wantKeepAlive => true;

}
