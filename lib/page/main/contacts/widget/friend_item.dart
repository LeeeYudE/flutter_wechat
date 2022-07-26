import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/contacts/friend_detail_page.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../../color/colors.dart';
import '../../../../utils/navigator_utils.dart';
import '../../../../utils/utils.dart';
import '../../../../widget/avatar_widget.dart';

class FriendItem extends StatelessWidget {

  LCObject friend;
  LCObject? lastFriend;
  int? selectType;///0未选中 1选中 -1 不可选中
  ValueChanged<LCObject>? onTap;

  FriendItem({required this.friend,required this.lastFriend,this.selectType,this.onTap,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapWidget(
      onTap:() {
        if(onTap != null){
          if(selectType != -1) {
            onTap?.call(friend);
          }
        }else{
          NavigatorUtils.toNamed(FriendDetailPage.routeName,arguments: friend['followee']['username']);
        }
      },
      child: Column(
        children: [
          if(lastFriend == null || friend['pinyin'] != lastFriend!['pinyin'])
          Container(
            height: 50.w,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            color: Colours.c_EEEEEE,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(friend['pinyin'],style: TextStyle(color: Colours.c_666666,fontSize: 28.sp),)),
          ),
          Container(
            height: 100.w,
            color: Colours.white,
            margin: EdgeInsets.only(bottom: 1.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if(selectType != null)
                  Container(
                      margin: EdgeInsets.only(right: 20.w),
                      child: Opacity(opacity: selectType == -1?0.5:1,
                      child: Image.asset(Utils.getIconImgPath(selectType == 0 ?'icon_no_select':'icon_selected'),width: 40.w,height: 40.w,))),
                AvatarWidget(avatar: friend['followee']['avatar'], weightWidth: 80.w,),
                20.sizedBoxW,
                Expanded(
                  child: Text(friend['followee']['nickname']??'name',style: TextStyle(color: Colours.black,fontSize: 32.sp),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
