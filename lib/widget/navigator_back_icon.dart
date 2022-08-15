import 'package:flutter/material.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../color/colors.dart';
import '../utils/navigator_utils.dart';

class NavigatorBackIcon extends StatelessWidget {

  Color? color;

  NavigatorBackIcon({this.color,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapWidget(child: Icon(
      Icons.arrow_back_ios_new,color: color??Colours.white,
    ), onTap: (){
      NavigatorUtils.pop();
    });
  }
}
