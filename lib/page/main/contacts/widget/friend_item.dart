import 'package:flutter/cupertino.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/contacts/friend_detail_page.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../../color/colors.dart';
import '../../../../utils/navigator_utils.dart';
import '../../../../widget/avatar_widget.dart';
import '../new_friend_page.dart';

class FriendItem extends StatelessWidget {

  LCObject friend;

  FriendItem({required this.friend,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapWidget(
      onTap: () {
        NavigatorUtils.toNamed(FriendDetailPage.routeName,arguments: friend['followee']['username']);
      },
      child: Container(
        height: 100.w,
        color: Colours.white,
        margin: EdgeInsets.only(bottom: 1.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AvatarWidget(avatar: friend['followee']['avatar'], weightWidth: 80.w,),
            20.sizedBoxW,
            Expanded(
              child: Text(friend['followee']['nickname']??'name',style: TextStyle(color: Colours.black,fontSize: 32.sp),),
            ),
          ],
        ),
      ),
    );
  }
}
