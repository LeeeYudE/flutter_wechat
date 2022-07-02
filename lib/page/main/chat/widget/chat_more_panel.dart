import 'package:flutter/material.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/tap_widget.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '../../../../color/colors.dart';
import '../../../../language/strings.dart';
import '../../../../utils/utils.dart';
import '../../map/select_address_page.dart';

class ChatMorePanel extends StatelessWidget {
  const ChatMorePanel({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.c_EEEEEE,
      padding: EdgeInsets.symmetric(vertical: 30.w),
      child: Column(
        children: [
          Expanded(child: Row(
            children: [
              _buildItem(context,'ic_details_photo',Ids.album.str(),0),
              _buildItem(context,'ic_details_camera',Ids.shoot.str(),1),
              _buildItem(context,'ic_details_localtion',Ids.location.str(),2),
              _buildItem(context,'ic_details_red',Ids.red_package.str(),3),
            ],
          )),
          Expanded(child: Row(
            children: [
              _buildItem(context,'ic_details_file',Ids.file.str(),4),
              _buildItem(context,'ic_details_favorite',Ids.favorite.str(),5),
              const Spacer(),
              const Spacer(),
            ],
          )),
        ],
      ),
    );
  }

  _buildItem(BuildContext context,String icon , String lable,int type){
    return Expanded(child: Center(
      child: TapWidget(
        onTap: () async {
          switch(type){
            case 0:
              final List<AssetEntity>? result = await AssetPicker.pickAssets(context,pickerConfig: const AssetPickerConfig(maxAssets: 1,requestType:RequestType.image ));
              if(result?.isNotEmpty??false){

              }
              break;
            case 1:
              final AssetEntity? entity = await CameraPicker.pickFromCamera(context,pickerConfig: const CameraPickerConfig(enableRecording: true));
              break;
            case 2:
              NavigatorUtils.toNamed(SelectAddressPage.routeName);
              break;
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: Colours.white.boxDecoration(borderRadius: 24.w),
              width: 110.w,
              height: 110.w,
              child: Center(
                child: Image.asset(Utils.getImgPath(icon,dir: Utils.DIR_CHAT,format: Utils.WEBP,)),
              ),
            ),
            5.sizedBoxH,
            Text(lable,style: TextStyle(color: Colours.c_999999,fontSize: 24.sp),)
          ],
        ),
      ),
    ));
  }
}
