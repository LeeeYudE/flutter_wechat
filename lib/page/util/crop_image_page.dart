import 'dart:io';

import 'package:get/get.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/common_btn.dart';
import '../../language/strings.dart';
import '../../widget/tap_widget.dart';

class CropImagePage extends StatefulWidget {

  static const String routeName='/CropImagePage';

  CropImagePage({Key? key}) : super(key: key);


  @override
  _CropImagePageState createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {

  late File file;

  final cropKey = GlobalKey<CropState>();

  @override
  void initState() {

    super.initState();
    file = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Stack(
            children: [
              Crop.file(
                file,
                key: cropKey,
                aspectRatio: 1,
                alwaysShowGrid: true,
              ),
              _buildBtn()
            ],
          ),
        ));
  }

  _buildBtn(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 50.w,left: 40.w,right: 40.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TapWidget(onTap: () {
              NavigatorUtils.pop();
            },
            child: Text(Ids.cancel.str(),style: TextStyle(color: Colours.white,fontSize: 28.sp),)),
            CommonBtn(text: Ids.confirm.str(), onTap: (){
              _crop(file);
            }, height: 60.w, width: 150.w,)
          ],
        ),
      ),
    );
  }

  Future<void> _crop(File originalFile) async {
    final crop = cropKey.currentState!;
    final area = crop.area;
    if (area == null) {
      //裁剪结果为空
      print('裁剪不成功');
      return;
    }
    await  ImageCrop.cropImage(
      file: originalFile,
      area: crop.area!,
    ).then((value) {
      upload(value);
    });
  }

  ///上传头像
  void upload(File file) {
    NavigatorUtils.pop(file);
  }
}