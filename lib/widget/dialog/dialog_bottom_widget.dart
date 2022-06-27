import 'package:flutter/cupertino.dart';
import 'package:wechat/widget/tap_widget.dart';
import '../../color/colors.dart';
import 'package:wechat/core.dart';

import '../../language/strings.dart';
import '../../utils/navigator_utils.dart';

class DialogBottomWidgetItem{

  String lable;
  int type;

  DialogBottomWidgetItem(this.lable, this.type);
}

class DialogBottomWidget extends StatelessWidget {

  List<DialogBottomWidgetItem> items;

  DialogBottomWidget(this.items,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Colours.white.radiusDecoration(topLeft: 24.w,topRight: 24.w),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
          items.map<Widget>((e){
            return TapWidget(
              onTap: () {
                NavigatorUtils.pop(e.type);
              },
              child: Container(
                height: 100.w,
                decoration: Colours.c_EEEEEE.bottomBorder(bgColor: Colours.white),
                child: Center(child: Text(e.lable,style: TextStyle(color: Colours.black,fontSize: 32.sp),)),
              ),
            );
          }).toList()
            ..add(
                Container(
                  height: 10.w,
                  color: Colours.c_EEEEEE,
                )
            )
            ..add(
              SizedBox(
                height: 100.w,
                child: Center(child: Text(Ids.cancel.str(),style: TextStyle(color: Colours.black,fontSize: 32.sp),)),
              )
          )
      ),
    );
  }
}
