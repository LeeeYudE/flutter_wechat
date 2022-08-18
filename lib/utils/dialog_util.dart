import 'dart:io';

import 'package:wechat/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '../color/colors.dart';
import '../language/strings.dart';
import '../page/util/crop_image_page.dart';
import '../widget/dialog/dialog_bottom_widget.dart';
import 'image_util.dart';


class DialogUtil{

  static showLoading({String? msg}){
    SmartDialog.showLoading(
      msg:msg?? Ids.waiting.str(),
      backDismiss: false
    );
  }

  static disimssLoading(){
    SmartDialog.dismiss();
  }

  static Future<bool?> showConfimDialog(BuildContext context,String title) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(Ids.tips.str()),
            content: Text(title),
            actions: <Widget>[
              TextButton(child: Text(Ids.cancel.str(),style: const TextStyle(color: Colours.c_E9465D),),onPressed: (){
                Navigator.pop(context,false);
              },),
              TextButton(child: Text(Ids.confirm.str()),onPressed: (){
                Navigator.pop(context,true);
              },),
            ],
          );
        });
  }

  static Future<File?> choosePhotoDialog(BuildContext context ,{bool crop = false,double aspectRatio = 1.0,bool compress = true,bool isVideo = false}) async {
  var result =  await NavigatorUtils.showBottomItemsDialog([DialogBottomWidgetItem(Ids.shoot.str(),1),DialogBottomWidgetItem(Ids.album.str(),0)]);
  File? file;
    switch(result){
      case 0:
        final List<AssetEntity>? result = await AssetPicker.pickAssets(context,pickerConfig: AssetPickerConfig(maxAssets: 1,requestType:isVideo ?  RequestType.video: RequestType.image));
        if(result?.isNotEmpty??false){
          file = await result?.first.originFile;
        }
        break;
      case 1:
        final AssetEntity? entity = await CameraPicker.pickFromCamera(context,pickerConfig: CameraPickerConfig(enableRecording: isVideo,onlyEnableRecording: isVideo));
        if(entity != null){
          file = await entity.file;
        }
        break;
    }
    if(isVideo){
      return file;
    }
    if(file != null && crop){
      file =  await NavigatorUtils.toNamed(CropImagePage.routeName,arguments: CropArguments(file: file,aspectRatio: 1.00));
      if(file != null){
        String? _image = await ImageUtil.compressImage(file);
        if(_image != null){
          file = File(_image);
        }
      }
      return file;
    }else{
      if(file != null && compress){
        String? _image = await ImageUtil.compressImage(file);
        if(_image != null){
          file = File(_image);
        }
      }
      return file;
    }

  }

}