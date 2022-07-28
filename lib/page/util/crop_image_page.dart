import 'dart:io';

import 'package:get/get.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:flutter/material.dart';
import 'package:wechat/utils/dialog_util.dart';
import 'package:wechat/utils/file_utils.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/common_btn.dart';
import '../../language/strings.dart';
import '../../widget/tap_widget.dart';

import 'package:crop_your_image/crop_your_image.dart';

class CropArguments{

  File file;
  double? aspectRatio;

  CropArguments({required this.file, this.aspectRatio});

}

class CropImagePage extends StatefulWidget {

  static const String routeName = '/CropImagePage';

  CropImagePage({Key? key}) : super(key: key);


  @override
  _CropImagePageState createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {

  late CropArguments arguments;

  // final cropKey = GlobalKey<CropState>();

  @override
  void initState() {
    super.initState();
    arguments = Get.arguments;
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
              buildCrop(context),
              _buildBtn()
            ],
          ),
        ));
  }

  final _cropController = CropController();

  Widget buildCrop(BuildContext context) {
    return Crop(
        image: arguments.file.readAsBytesSync(),
        controller: _cropController,
        onCropped: (image) async {
          var fileDirectory = await FileUtils.getImageTemporaryDirectory();
          var file = File(fileDirectory.path+DateUtil.getNowDateMs().toString()+'.jpg');
          file.writeAsBytesSync(image.toList());
          DialogUtil.disimssLoading();
          NavigatorUtils.pop(file);
        },
        aspectRatio: arguments.aspectRatio??1,
        initialSize: 1,
        // initialArea: Rect.fromLTWH(240, 212, 800, 600),
        // initialAreaBuilder: (rect) => Rect.fromLTRB(
        //     rect.left + 24, rect.top + 32, rect.right - 24, rect.bottom - 32
        // ),
        // withCircleUi: true,
        baseColor: Colors.black,
        maskColor: Colours.black_transparent,
        onMoved: (newRect) {
          // do something with current cropping area.
        },
        onStatusChanged: (status) {
          // do something with current CropStatus
        },
        // cornerDotBuilder: (size, edgeAlignment) => const DotControl(color: Colors.white,),
        interactive: false,
    // fixArea: true,
    );
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
              _crop();
            }, height: 60.w, width: 150.w,)
          ],
        ),
      ),
    );
  }

  Future<void> _crop() async {
    _cropController.crop();
    DialogUtil.showLoading();
    // final crop = cropKey.currentState!;
    // final area = crop.area;
    // if (area == null) {
    //   //裁剪结果为空
    //   print('裁剪不成功');
    //   return;
    // }
    // await  ImageCrop.cropImage(
    //   file: originalFile,
    //   area: crop.area!,
    // ).then((value) {
    //   upload(value);
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

}