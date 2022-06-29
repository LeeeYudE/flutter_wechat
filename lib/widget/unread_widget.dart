import 'package:wechat/core.dart';
import 'package:flutter/material.dart';

class UnreadWidget extends StatelessWidget {

  int? unread_count;
  Color? bgColor;
  Color? textColor;
  bool noZero;

  UnreadWidget(this.unread_count,{this.bgColor,this.textColor,this.noZero = true});


  @override
  Widget build(BuildContext context) {
    bgColor ??= const Color(0xFFFF3A16);
    textColor ??= Colors.white;

    if(unread_count! < 0){
      unread_count = 0;
    }else if(unread_count! > 99){
      unread_count = 99;
    }

    return Offstage(
      offstage: unread_count == null || ( noZero && unread_count == 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20.w)),
        child: Container(
          constraints: BoxConstraints(
            minWidth: 20.w,
            minHeight: 20.w,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                getCount(),
                style: TextStyle(color: textColor, fontSize: 18.sp,fontWeight: FontWeight.bold,textBaseline: TextBaseline.alphabetic,height: 1),
              )],
          ),
        ),
      ),
    );
  }

  String getCount(){
    if(unread_count == null){
      return '0';
    }
    if(unread_count! > 99){
      return '99+';
    }
    return unread_count.toString();
  }

}
