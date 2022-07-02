import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/tap_widget.dart';
import '../../../color/colors.dart';
import '../../../controller/user_controller.dart';
import '../../../language/strings.dart';
import '../../../utils/utils.dart';
import '../../../widget/avatar_widget.dart';
import '../../../widget/dialog/dialog_bottom_widget.dart';


///二维码名片页面
class QrcodeBusinessCardPage extends StatefulWidget {

  static const String routeName = '/QrcodeBusinessCardPage';

  const QrcodeBusinessCardPage({Key? key}) : super(key: key);

  @override
  State<QrcodeBusinessCardPage> createState() => _QrcodeBusinessCardPageState();
}

class _QrcodeBusinessCardPageState extends State<QrcodeBusinessCardPage> {

  final GlobalKey _repaintKey = GlobalKey(); // 可以获取到被截图组件状态的 GlobalKey

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: Ids.qrcode_business_card.str(),
      appbarColor: Colours.c_EEEEEE,
      body: _buildBody(context),
      actions: [
        TapWidget(onTap: () async {
         var result = await  NavigatorUtils.showBottomItemsDialog(
            [
              DialogBottomWidgetItem(Ids.save_to_phone.str(),0)
            ]
          );
         if(result == 0) {
           _repaintKey.doSaveImage();
         }
        }, child: Image.asset(Utils.getImgPath('ic_more_black',dir: Utils.DIR_ICON,),width: 40.w,height: 40.w,))
      ],
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      color: Colours.c_EEEEEE,
      padding: EdgeInsets.only(left: 40.w,right: 40.w),
      child: Center(
        child: Container(
          decoration: Colours.white.boxDecoration(borderRadius: 12.w),
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AvatarWidget(avatar: UserController.instance.user?.avatar, weightWidth: 150.w,),
                  20.sizedBoxW,
                  Text(UserController.instance.user?.nickname??'name',style: TextStyle(color: Colours.black,fontSize: 48.sp),),
                ],
              ),
              40.sizedBoxH,
              RepaintBoundary(
                key: _repaintKey,
                child: Container(
                  width: 600.w,
                  height: 600.w,
                  color: Colours.white,
                  child: Stack(
                    children: [
                      QrImage(
                        data: UserController.instance.user?.username??'',
                        version: QrVersions.auto,
                        size: 600.w,
                      ),
                      Center(child: AvatarWidget(avatar: UserController.instance.user?.avatar, weightWidth: 150.w,decorationWidth: 10.w,)),
                    ],
                  ),
                ),
              ),
              40.sizedBoxH,
              Text(Ids.scan_qrcode_business_card.str(),style: TextStyle(color: Colours.c_CCCCCC,fontSize: 28.sp),),
              20.sizedBoxH,
            ],
          ),
        ),
      ),
    );
  }

}
