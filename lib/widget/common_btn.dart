import 'package:flutter/material.dart';

import 'package:wechat/core.dart';
import '../color/colors.dart';

class CommonBtn extends StatefulWidget {

  TextStyle? textStyle;
  GestureTapCallback? onTap;
  String? text;
  Color? backgroundColor;
  String? icon;
  double? iconSize;
  double? borderRadius;
  double? width;
  double? height;
  bool enable;

  CommonBtn({Key? key, required this.text,required this.width, required this.height,required this.onTap,this.textStyle,this.backgroundColor,this.icon,this.iconSize,this.borderRadius,this.enable = true}) : super(key: key);

  @override
  State<CommonBtn> createState() => _CommonBtnState();
}

class _CommonBtnState extends State<CommonBtn> {
  bool _isPan = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enable?widget.onTap:null,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: _isPan && widget.enable ?0.8:1,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor??Colours.currentColor(),
            borderRadius: BorderRadius.circular(widget.borderRadius??10.w),
          ),
          width: widget.width??80.w,
          height:  widget.height??300.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if(widget.icon != null)
                Container(
                    margin: EdgeInsets.only(right: 10.w),
                    child: Image.asset(widget.icon!,width: widget.iconSize,height: widget.iconSize,)),
              Text(widget.text!,style: widget.textStyle??TextStyle(color: Colours.c_ffffff,fontSize: 32.sp),)
            ],
          ),
        ),
      ),
      onPanDown: (DragDownDetails details){
        setState((){
          _isPan = true;
        });
      },
      onPanUpdate: (DragUpdateDetails details){
        setState((){
          _isPan = false;
        });
      },
      onPanCancel: (){
        setState((){
          _isPan = false;
        });
      },
    );
  }
}
