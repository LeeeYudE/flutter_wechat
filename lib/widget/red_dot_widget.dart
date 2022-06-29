import 'package:flutter/material.dart';
import 'package:wechat/core.dart';

class RedDotWidget extends StatelessWidget {

  final double? width;
  final double? top;
  final double? right;
  final double? left;

   RedDotWidget(
      {Key? key,this.top,this.right,this.left,this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: top??0,
        left: left??0,
        right: right??0,
      ),
      width: width??18.w,
      height: width??18.w,
      decoration: BoxDecoration(
        color: const Color(0xFFE73E24),
        borderRadius: BorderRadius.circular(width??18.w),
      ),
    );
  }
}
