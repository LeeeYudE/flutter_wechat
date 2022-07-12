import 'dart:math';

import 'package:flutter/material.dart';

class CustomPwdField extends StatelessWidget {
  final String data;
  final int pwdLength;

  const CustomPwdField(this.data, this.pwdLength, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PwdField(data, pwdLength),
    );
  }
}

class PwdField extends CustomPainter {
  String data;
  int pwdLength;

  PwdField(this.data, this.pwdLength);

  @override
  void paint(Canvas canvas, Size size) {
    // 密码画笔
    Paint mPwdPaint;
    Paint mRectPaint;

    // 初始化密码画笔
    mPwdPaint = Paint();
    mPwdPaint.color = Colors.black;
    // 初始化密码框
    mRectPaint = Paint();
    mRectPaint.color = const Color(0xffcccccc);

    final RRect r =
        RRect.fromLTRBR(0.0, 0.0, size.width, size.height,const Radius.circular(0));
    mRectPaint.style = PaintingStyle.stroke;
    canvas.drawRRect(r, mRectPaint);

    final per = size.width / pwdLength;
    var offsetX = per;
    //画密码框框
    while (offsetX < size.width) {
      canvas.drawLine(
          Offset(offsetX, 0.0), Offset(offsetX, size.height), mRectPaint);
      offsetX += per;
    }

    final half = per / 2;
    final radio = per / 8;

    mPwdPaint.style = PaintingStyle.fill;
    //画密码点点
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length && i < 6; i++) {
        canvas.drawArc(
            Rect.fromLTRB(i * per + half - radio, size.height / 2 - radio,
                i * per + half + radio, size.height / 2 + radio),
            0.0,
            2 * pi,
            true,
            mPwdPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
