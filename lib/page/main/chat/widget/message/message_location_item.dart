import 'package:flutter/material.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/tap_widget.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import '../../../../../color/colors.dart';
import '../../../../../language/strings.dart';
import '../../../../../widget/cache_image_widget.dart';
import '../../../map/preview_loctaion_page.dart';

class MessageLocationItem extends StatelessWidget {

  LocationMessage message;

  MessageLocationItem({required this.message,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapWidget(
      onTap: () {
        NavigatorUtils.toNamed(PreviewLocationPage.routeName,arguments: BMFCoordinate(message.latitude!,message.longitude!));
      },
      child: Container(
        decoration: Colours.white.boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80.w,
              padding: EdgeInsets.only(left: 20.w),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(Ids.location.str(),style: TextStyle(color: Colours.black,fontSize: 32.sp),)),
            ),
            CacheImageWidget(url: message.addressUrl, weightHeight: 150.w, weightWidth: 400.w,)
          ],
        ),
      ),
    );
  }
}
