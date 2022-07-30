import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/discover/friend_circle_page.dart';
import 'package:wechat/page/main/discover/scan_qrcode_page.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/utils/utils.dart';

import '../../../language/strings.dart';
import '../../../widget/lable_widget.dart';
import '../widget/main_appbar.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        Ids.discover.str(),
        _buildBody()
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        LableWidget(lable:Ids.friends_circle.str
          (),leftWidget: Image.asset(Utils.getImgPath('ff_Icon_album',dir: Utils.dir_discover,format:Utils.WEBP),width: 50.w,height: 50.w,),onTap:(){
          NavigatorUtils.toNamed(FriendCirclePage.routeName);
        }),
        Colours.c_EEEEEE.toLine(20.w),
        LableWidget(lable:Ids.scan.str
          (),leftWidget: Image.asset(Utils.getImgPath('ff_Icon_qr_code',dir: Utils.dir_discover,format:Utils.WEBP ),width: 50.w,height: 50.w),onTap:(){
          NavigatorUtils.toNamed(ScanQrcodePage.routeName);
        }),
        Colours.c_EEEEEE.toLine(1.w),
        LableWidget(lable:Ids.friends_circle.str
          (),leftWidget: Image.asset(Utils.getImgPath('ff_Icon_shake',dir: Utils.dir_discover,format:Utils.WEBP ),width: 50.w,height: 50.w),onTap:(){

        }),
      ]
      ,
    );
  }
}
