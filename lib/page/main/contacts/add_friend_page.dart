import 'package:flutter/material.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/contacts/search_friend_page.dart';
import 'package:wechat/widget/base_scaffold.dart';

import '../../../color/colors.dart';
import '../../../language/strings.dart';
import '../../../utils/navigator_utils.dart';
import '../../../utils/utils.dart';
import '../../../widget/tap_widget.dart';
import '../mine/qrcode_business_card_page.dart';

class AddFriendPage extends StatefulWidget {

  static const String routeName = '/AddFriendPage';

  const AddFriendPage({Key? key}) : super(key: key);

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: Ids.add_friend.str(),
      appbarColor: Colours.c_EEEEEE,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Column(
      children: [
        TapWidget(
          onTap: () async {
           var result = await NavigatorUtils.toNamed(SearchFriendPage.routeName);
           if(result??false){
             NavigatorUtils.pop();
           }
          },
          child: Container(
            height: 60.w,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: Colours.white.boxDecoration(borderRadius: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Utils.getImgPath('search_white',dir: Utils.DIR_ICON),color: Colours.c_999999,width: 40.w,height: 40.w,),
                10.sizedBoxW,
                Text(Ids.accound_and_phone.str(),style: TextStyle(color: Colours.c_999999,fontSize: 32.sp),)
              ],
            ),
          ),
        ),
        10.sizedBoxH,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${Ids.accound_and_phone.str()} ${UserController.instance.user?.wxId}',style: TextStyle(color: Colours.c_999999,fontSize: 24.sp),),
            10.sizedBoxW,
            TapWidget(onTap: () {
              NavigatorUtils.toNamed(QrcodeBusinessCardPage.routeName);
            }, child: Image.asset(Utils.getImgPath('ic_small_code',dir: Utils.DIR_MINE),width: 30.w,height: 30.w,)),
          ],
        )
      ],
    );
  }
}
