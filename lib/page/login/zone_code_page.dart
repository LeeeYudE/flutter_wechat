import 'package:azlistview/azlistview.dart';
import 'package:wechat/core.dart';
import 'package:flutter/material.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../color/colors.dart';
import '../../language/strings.dart';
import 'controller/zone_code_controll.dart';

class ZoneCodePage extends BaseGetBuilder<ZoneCodeController> {

  static const String routeName = '/ZoneCodePage';

  ZoneCodePage({Key? key}) : super(key: key);

  @override
  ZoneCodeController? getController() => ZoneCodeController();


  @override
  Widget controllerBuilder(BuildContext context, ZoneCodeController controller) {
    return MyScaffold(
      title: Ids.title_country_and_area.str(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        AzListView(
          data: controller.zoneCodeList, itemBuilder: (BuildContext context, int index) {
          var zoneCode = controller.zoneCodeList[index];
            return TapWidget(
              onTap: () {
                NavigatorUtils.pop(zoneCode);
              },
              child: Container(
                padding: EdgeInsets.only(left: 20.w,right: 60.w),
                height: 100.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(zoneCode.name??'',style: TextStyle(color: Colours.black,fontSize: 32.sp),),
                    Container(
                      decoration: Colours.c_EEEEEE.boxDecoration(borderRadius: 6.w),
                      padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.w),
                      child: Text(zoneCode.tel??'',style: TextStyle(color: Colours.c_666666,fontSize: 28.sp),),
                    )
                  ],
                ),
              ),
            );
        }, itemCount: controller.zoneCodeList.length,
        )
      ],
    );
  }

}
