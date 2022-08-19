import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/tap_widget.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '../../../../color/colors.dart';
import '../../../../language/strings.dart';
import '../../../../utils/utils.dart';
import '../../map/select_location_page.dart';
import '../controller/chat_controller.dart';
import '../page/red_packet/send_red_packet_page.dart';

class ChatMorePanel extends StatelessWidget {

  ChatMorePanel({Key? key}) : super(key: key);

  final ChatController _chatController = Get.find();

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
            case 0:///相册
              final List<AssetEntity>? result = await AssetPicker.pickAssets(context,pickerConfig: const AssetPickerConfig(maxAssets: 1,requestType:RequestType.common ));
              if(result?.isNotEmpty??false){
                File file =  (await result!.first.originFile)!;
                if(file.filename.endsWith('mp4')){
                  _chatController.sendVideo(file);
                }else{
                  _chatController.sendImage(file);
                }
              }
              break;
            case 1:///拍摄
              final AssetEntity? entity = await CameraPicker.pickFromCamera(context,pickerConfig: const CameraPickerConfig(enableRecording: true,resolutionPreset: ResolutionPreset.high));
              if(entity != null){
                var file = await entity.file;
                if(file != null){
                  if(file.filename.endsWith('mp4')){
                    _chatController.sendVideo(file);
                  }else{
                    _chatController.sendImage(file);
                  }
                }
              }
              break;
            case 2:///位置
             var poi = await NavigatorUtils.toNamed(SelectLocationPage.routeName);
             if(poi != null){
              _chatController.sendLocation(poi);
             }
              break;
            case 3:///红包
              NavigatorUtils.toNamed(SendRedPacketPage.routeName,arguments:_chatController.conversation);
              break;
            case 4:///文件
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if(result?.files.isNotEmpty??false){
                _chatController.sendFile(File(result!.files.first.path!));
              }
              break;
            case 5:///收藏
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
