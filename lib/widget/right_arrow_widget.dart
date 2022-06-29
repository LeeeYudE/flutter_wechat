import 'package:flutter/cupertino.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../utils/utils.dart';

class RightArrowWidget extends StatelessWidget {

  String lable;
  String? leftIcon;
  VoidCallback callback;

  RightArrowWidget({required this.lable ,required this.callback,this.leftIcon,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapWidget(
      onTap: callback,
      child: Container(
        color: Colours.white,
        height: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(leftIcon != null)
              Container(
                  margin: EdgeInsets.only(right: 20.w),
                  child: Image.asset(leftIcon!,width: 50.w,height: 50.w,)),
            Text(lable,style: TextStyle(color: Colours.black,fontSize: 32.sp),),
            const Spacer(),
            Image.asset(Utils.getImgPath('ic_right_arrow_grey',dir: Utils.DIR_ICON,format: Utils.WEBP),width: 20.w,height: 20.w,),
          ],
        ),
      ),
    );
  }
}
