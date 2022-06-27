import 'package:flutter/cupertino.dart';

import '../utils/datetime_util.dart';

class TapWidget extends StatelessWidget {

  ///防止重复点击
  static const int CLICK_TIME = 200;

  Widget child;
  GestureTapCallback onTap;
  int _lastClickTime = 0;

  TapWidget({Key? key, required this.child,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      behavior: HitTestBehavior.opaque,
      onTap:(){
        var dateTimeNowMilli = DateTimeUtil.dateTimeNowMilli();
        if(dateTimeNowMilli - _lastClickTime > CLICK_TIME){
          _lastClickTime = dateTimeNowMilli;
          onTap.call();
        }
      } ,
    );
  }
}
