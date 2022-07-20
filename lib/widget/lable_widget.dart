import 'package:flutter/material.dart';
import 'package:wechat/widget/tap_widget.dart';
import 'package:wechat/core.dart';
import '../color/colors.dart';

class LableWidget extends StatelessWidget {

  String lable;
  Widget? rightWidget;
  Widget? leftWidget;
  GestureTapCallback? onTap;

  LableWidget({required this.lable,this.leftWidget,this.rightWidget,this.onTap,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapWidget(
      onTap: onTap??(){},
      child: Container(
        color: Colours.white,
        constraints: BoxConstraints(minHeight: 100.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(leftWidget != null)
              Container(
                margin: EdgeInsets.only(right: 20.w),
                child: leftWidget,
              ),
            Text(lable,style: TextStyle(color: Colours.black,fontSize: 28.sp),),
            const Spacer(),
            if(rightWidget != null)
              Container(
                margin: EdgeInsets.only(right: 10.w),
                child: rightWidget,
              ),
            const Icon(Icons.keyboard_arrow_right,color: Colours.c_999999,)
          ],
        ),
      ),
    );
  }

}
