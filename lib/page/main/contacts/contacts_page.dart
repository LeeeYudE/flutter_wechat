import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/controller/friend_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/remove_top_widget.dart';

import '../../../language/strings.dart';
import '../../../utils/utils.dart';
import '../../../widget/clip_rect_widget.dart';
import '../../../widget/tap_widget.dart';
import '../widget/main_appbar.dart';
import 'widget/friend_item.dart';
import 'new_friend_page.dart';

class ContactsPage extends BaseGetBuilder<FriendController>{

  final IndexBarController _indexBarController = IndexBarController();
  final IndexBarDragListener _barDragListener = IndexBarDragListener.create();
  final AutoScrollController _scrollController = AutoScrollController();

  @override
  void onInit() {
    _barDragListener.dragDetails.addListener(() {
      _scrollToTag(_barDragListener.dragDetails.value.tag);
    });
    super.onInit();
  }

  _scrollToTag(String? tag){
    if(tag != null){
      int _index = -1;
      controller.friends.forEachIndex((index, value) {
        if(tag == value['pinyin']){
          _index = index;
          return;
        }
      });
      if(_index != -1){
        _scrollController.scrollToIndex(_index + 1,duration: const Duration(milliseconds: 50),preferPosition:AutoScrollPosition.begin);
      }
    }
  }

  @override
  Widget controllerBuilder(BuildContext context, FriendController controller) {
    return MainScaffold(
        Ids.contacts.str(),
        _buildBody(controller)
    );
  }

  Widget _buildBody(FriendController controller) {
    return Stack(
      children: [
        Obx(()=> RemoveTopPaddingWidget(child: ListView.builder(itemBuilder: (context , index){
          if(index == 0){
            return _buildHeader();
          }
          return AutoScrollTag(
            key: ValueKey(index),
          index: index,
          controller: _scrollController,
          child: FriendItem(friend: controller.friends[index-1], lastFriend: controller.friends.safetyItem(index-2),));
        },itemCount: controller.friends.length + 1,controller: _scrollController,)),
        ),
        _buildIndexBar()
      ],
    );
  }

  _buildHeader(){
    return AutoScrollTag(
      key: const ValueKey(0),
      index: 0,
      controller: _scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeaderItem('ic_new_friend',Ids.new_friend.str(),0),
          _buildHeaderItem('ic_group',Ids.group_chat.str(),1),
          _buildHeaderItem('ic_tag',Ids.lable.str(),2),
        ],
      ),
    );
  }

  _buildHeaderItem(String icon,String title,int type){
    return TapWidget(
      onTap: () {
        switch(type){
          case 0:
            NavigatorUtils.toNamed(NewFriendPage.routeName);
            break;
        }
      },
      child: Container(
        height: 100.w,
        decoration:Colours.c_EEEEEE.bottomBorder(bgColor: Colours.white),
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.w),
        child: Row(
          children: [
            ClipRectWidget(child: Image.asset(Utils.getImgPath(icon,dir:Utils.DIR_CONTACT,format: Utils.WEBP),width: 80.w,height: 80.w,)),
            40.sizedBoxW,
            Text(title,style: TextStyle(color: Colours.black,fontSize: 32.sp),),
          ],
        ),
      ),
    );
  }

  _buildIndexBar(){
    return Align(
      alignment: Alignment.centerRight,
      child: IndexBar(
        data: FriendController.tags,
        itemHeight: 30.w,
        margin: EdgeInsets.only(bottom: 10.w),
        indexHintBuilder: (BuildContext context, String tag){
          return Text(tag,style: TextStyle(color: Colours.c_EEEEEE,fontSize: 24.sp),);
        },
        indexBarDragListener: _barDragListener,
        controller: _indexBarController,
      ),
    );
  }

  @override
  FriendController? getController() => null;

}
