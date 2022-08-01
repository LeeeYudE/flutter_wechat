import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/controller/auido_manager.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/lottie_widget.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wechat/widget/subscription_mixin.dart';
import '../../../language/strings.dart';

class ShakePage extends StatefulWidget {

  static const String routeName = '/ShakePage';

  const ShakePage({Key? key}) : super(key: key);

  @override
  State<ShakePage> createState() => _ShakePageState();
}

class _ShakePageState extends State<ShakePage> with SingleTickerProviderStateMixin , SubscriptionMixin {

  late StreamSubscription _subscription;
  static const int accelerometerValue = 5;
  late Animation _animation;
  late AnimationController _controller;
  bool _shake = false;

  @override
  void initState() {
    _subscription =  userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      if (event.x >= accelerometerValue ||
          event.x <= -accelerometerValue ||
          event.y >= accelerometerValue ||
          event.y <= -accelerometerValue ||
          event.z >= accelerometerValue ||
          event.z <= -accelerometerValue) {
        if (_shake == false) {
          _shake = true;
          //延时两秒匹配到用户
          _controller.forward();
          AudioManager.instance.shake();
          delay(3000, (value) {
            _controller.reverse();
            _shake = false;
          });
        }
      }
      },
    );
    _controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 200.w).animate(_controller);
    _animation.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: Ids.shake.str(),
      appbarColor: Colours.black,
      body: _buildBody(context),
      backIconColor: Colours.white,
    );
  }

  _buildBody(BuildContext context) {
    return Stack(
      children: [
        _buildLottie(),
        Column(
          children: [
            _buildTopImage(),
            _buildBottomImage(),
          ],
        )
      ],
    );
  }

  _buildTopImage(){
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: _animation.value),
        child: Container(
          color: Colours.black,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(Utils.getImgPath('icon_shake_top',dir: Utils.dir_discover),fit: BoxFit.cover,width: 256.w,height: 128.w,),
          ),
        ),
      ),
    );
  }

  _buildBottomImage(){
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: _animation.value),
        child: Container(
          color: Colours.black,
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(Utils.getImgPath('icon_shake_bottom',dir: Utils.dir_discover),fit: BoxFit.cover,width: 256.w,height: 128.w,),
          ),
        ),
      ),
    );
  }

  _buildLottie(){
    return Center(
      child: Container(
        height: 400.w,
        width: double.infinity,
        color: Colours.c_4B4C52,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieWidget(assetPath: Utils.getLottiePath('heartbeat'), height: 200.w,width: 200.w,),
            20.sizedBoxH,
            Text('正在搜索同一时刻摇晃手机的人',style: TextStyle(color: Colours.c_999999,fontSize: 28.sp),)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

}
