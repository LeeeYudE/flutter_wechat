import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/widget/common_btn.dart';
import 'package:wechat/core.dart';

import '../../../../language/strings.dart';
import '../controller/chat_controller.dart';

class SendMessageBtn extends StatefulWidget {
  const SendMessageBtn({Key? key}) : super(key: key);

  @override
  State<SendMessageBtn> createState() => _SendMessageBtnState();
}

class _SendMessageBtnState extends State<SendMessageBtn> with TickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> bezier;//透明度渐变
  final ChatController _chatController = Get.find();
  bool forward = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 200),vsync: this);//初始化，动画控制器,每个动画都是执行2秒
    bezier = Tween<double>(begin: 0.0, end: 1.0,).animate(CurvedAnimation(parent: controller, curve: const Interval(0.0, 1.0,curve: Curves.ease),));
    _chatController.textController.addListener(() {
      if(_chatController.textController.text.trim().isNotEmpty){
        if(!forward){
          controller.forward();//开始
          forward = true;
        }
      }else{
        if(forward){
          controller.reverse();//开始
          forward = false;
        }
      }
    });
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity:bezier.value,
        child: CommonBtn(text: Ids.send.str(), width: 100 * bezier.value, height: 60.w * bezier.value, onTap: (){

        },textStyle: TextStyle(color: Colours.white,fontSize: 28.sp*bezier.value),),
      ),
    );
  }



}
