import 'dart:io';

import 'package:wechat/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../color/colors.dart';
import '../language/strings.dart';
import '../widget/choose_photo_methods_dialog.dart';


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

  static Future<File?> choosePhotoDialog(BuildContext context , String title ,{bool crop = false}){
   return showModalBottomSheet(
        backgroundColor: Colours.c15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtilExt.setWidth(60)),
              topRight: Radius.circular(ScreenUtilExt.setWidth(60))),
        ),
        context: context,
        builder: (BuildContext _context) {
          return ChoosePhotoMethodsDialog(
            title: title,
            crop: crop,
          );
        });
  }

}