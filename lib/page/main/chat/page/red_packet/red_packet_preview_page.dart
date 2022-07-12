import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:flutter/material.dart';
import 'package:wechat/page/main/chat/page/red_packet/controller/red_packet_controller.dart';
import 'package:wechat/page/main/chat/page/red_packet/red_packet_painter.dart';
import 'package:wechat/utils/navigator_utils.dart';

import '../../../../../widget/base_scaffold.dart';

///代码来源 https://juejin.cn/post/7075338022446694413
class RedPacketPreviewPage extends StatefulWidget {

  static const String routeName = '/RedPacketPreviewPage';

  RedPacketPreviewPage({Key? key}) : super(key: key);

  @override
  _RedPacketPreviewPageState createState() => _RedPacketPreviewPageState();
}

class _RedPacketPreviewPageState extends State<RedPacketPreviewPage> with TickerProviderStateMixin{

  late RedPacketController controller;

  @override
  void initState() {
    super.initState();
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
      backgroundColor: Colours.black_transparent,
      showAppbar: false,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: GestureDetector(
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
                  child: const Icon(Icons.close,color: Color(0xFFFCE5BF)),
                ),
              )
            ],
          ),
          onPanDown: (d) => controller.handleClick(d.globalPosition),
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
                ClipRRect(
                    borderRadius: BorderRadius.circular(3.w),
                    child: Image.network("https://p26-passport.byteacctimg.com/img/user-avatar/32f1f514b874554f69fe265644ca84e4~300x300.image", width: 24.w,)),
                SizedBox(width: 5.w,),
                Text("loongwind的红包", style: TextStyle(fontSize: 28.sp, color: const Color(0xFFF8E7CB), fontWeight: FontWeight.w500),)
              ],
            ),
            SizedBox(height: 15.w,),
            Text('恭喜发财', style: TextStyle(fontSize: 28.sp, color: const Color(0xFFF8E7CB)),)
          ],
        ),
      ),
    );
  }


}


