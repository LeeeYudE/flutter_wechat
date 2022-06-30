import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/controller/chat_manager_controller.dart';
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

  @override
  void onInit() {
    _barDragListener.dragDetails.addListener(() {

    });
    super.onInit();
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
          return FriendItem(friend: controller.friends[index-1],);
        },itemCount: controller.friends.length + 1,)),
        ),
        _buildIndexBar()
      ],
    );
  }

  _buildHeader(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderItem('ic_new_friend',Ids.new_friend.str(),0),
        _buildHeaderItem('ic_group',Ids.group_chat.str(),1),
        _buildHeaderItem('ic_tag',Ids.lable.str(),2),
      ],
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
