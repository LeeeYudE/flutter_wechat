import 'package:get/get.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/controller/member_controller.dart';
import 'package:wechat/core.dart';
import 'package:flutter/material.dart';
import 'package:wechat/page/main/chat/page/red_packet/controller/red_packet_controller.dart';
import 'package:wechat/page/main/chat/page/red_packet/widget/red_packet_painter.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/avatar_widget.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../../../widget/base_scaffold.dart';
import '../../model/red_packet_message.dart';

///代码来源 https://juejin.cn/post/7075338022446694413
class RedPacketPreviewPage extends StatefulWidget {

  static const String routeName = '/RedPacketPreviewPage';

  RedPacketPreviewPage({Key? key}) : super(key: key);

  @override
  _RedPacketPreviewPageState createState() => _RedPacketPreviewPageState();
}

class _RedPacketPreviewPageState extends State<RedPacketPreviewPage> with TickerProviderStateMixin{

  late RedPacketController controller;
  late RedPacketMessage _message;

  @override
  void initState() {
    super.initState();
    _message = Get.arguments;
    controller = RedPacketController(tickerProvider: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: Colours.white_transparent,
      showAppbar: false,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(parent: controller.scaleController, curve: Curves.fastOutSlowIn)),
                child: buildRedPacket(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 100.w),
                decoration: Colours.c_FA9E3B.borderDecoration(borderRadius: 50.w),
                padding: EdgeInsets.all(5.w),
                child: TapWidget(onTap: () {
                  NavigatorUtils.pop();
                },
                child: Icon(Icons.close,color: Colours.c_FA9E3B,size: 40.w,)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRedPacket() {
    return GestureDetector(
      onTapUp: controller.clickGold,
      child: CustomPaint(
        size: Size(1.0.sw, 1.0.sh),
        painter: RedPacketPainter(controller: controller),
        child: buildChild(),
      ),
    );
  }


  Widget buildChild() {
    var member = MemberController.instance.getMember(_message.fromClientID);
    return AnimatedBuilder(
      animation: controller.translateController,
      builder: (context, child) => Container(
        padding: EdgeInsets.only(top: 0.3.sh * (1 - controller.translateCtrl.value)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AvatarWidget(avatar: member?.avatar, weightWidth: 48.w),
                SizedBox(width: 5.w,),
                Text("${MemberController.instance.getMember(_message.fromClientID)?.nickname}的红包", style: TextStyle(fontSize: 28.sp, color: const Color(0xFFF8E7CB), fontWeight: FontWeight.w500),)
              ],
            ),
            SizedBox(height: 15.w,),
            Text(_message.text??'', style: TextStyle(fontSize: 28.sp, color: const Color(0xFFF8E7CB)),)
          ],
        ),
      ),
    );
  }


}


