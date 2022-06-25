import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/login/widget/verify_machine_painter.dart';
import 'dart:ui' as ui;
import 'package:wechat/page/login/widget/verify_machine_slide_widget.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/utils/utils.dart';

import '../../../language/strings.dart';
import '../../../widget/shake_widget.dart';
import '../../../widget/subscription_mixin.dart';

class VerifyMachineWidget extends StatefulWidget {
  const VerifyMachineWidget({Key? key}) : super(key: key);

  @override
  State<VerifyMachineWidget> createState() => _VerifyMachineWidgetState();
}

class _VerifyMachineWidgetState extends State<VerifyMachineWidget> with SubscriptionMixin {

  ui.Image? _image;
  double slideRatio = 0;
  double startRatio = 0.7;///拼图的百分比
  bool _checkError = false;
  final GlobalKey<ShakeWidgetState> _errorKey = GlobalKey<ShakeWidgetState>();

  /// 通过assets路径，获取资源图片
  Future<ui.Image> load() async {
    ByteData data = await rootBundle.load(Utils.getImgPath('verify_machine',dir: 'bg'));
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  void initState() {
    super.initState();
    load().then((value){
      setState(() {
        _image = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_checkError) Text(Ids.drag_the_lower_slider_to_complete_the_puzzle.str(),style: TextStyle(color: Colours.black,fontSize: 32.sp),) else ShakeWidget(key: _errorKey,autoShake: true,child: Text(Ids.check_machine_error.str(),style: TextStyle(color: Colours.c_E73E24,fontSize: 32.sp),)),
          20.sizedBoxH,
          CustomPaint(
            size: Size(double.infinity,400.w),
            painter: VerifyMachinePainter(_image,startRatio,slideRatio),
          ),
          20.sizedBoxH,
          VerifyMachineSlideWidget((slide){
            setState(() {
              slideRatio = slide;
            });
          },(){
            double result = slideRatio - startRatio;
            if((result > 0 && result < 0.1) || (result < 0 && result > -0.1)){
              Ids.check_machine_success.str().toast();
              delay(1000, (value) {
                NavigatorUtils.pop(true);
              });
            }else{
              _updateCheckError(true);
              delay(1000, (value) {
                _updateCheckError(false);
              });
            }
          }),
          20.sizedBoxH,
          Text(Ids.control_jigsaw_sliders.str(),style: TextStyle(color: Colours.c_FF4E32,fontSize: 32.sp),),
        ],
      ),
    );
  }

  _updateCheckError(bool status){
    setState(() {
      _checkError = status;
    });
  }

}
