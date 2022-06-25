import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';


class VerifyMachinePainter extends CustomPainter {

  static const BLOCK_SIZE = 100;

  Paint mPaint = Paint(); //主画笔
  Paint bgPaint = Paint(); //背景画笔
  ui.Image? image;
  double slideRatio;
  double startRatio;

  VerifyMachinePainter(this.image,this.startRatio,this.slideRatio){
    bgPaint..isAntiAlias = true //是否抗锯齿
    ..style = PaintingStyle.stroke //画笔样式：填充
    ..color= Colours.white//画笔颜色
    ..strokeWidth = 5.w;//画笔的宽度
    mPaint..isAntiAlias = true //是否抗锯齿
    ..style = PaintingStyle.stroke //画笔样式：填充
    ..color= Colours.black.withOpacity(0.3)//画笔颜色
    ..strokeWidth = 3.w;//画笔的宽度
  }

  @override
  void paint(Canvas canvas, Size size) {
    if(image != null){
      canvas.drawImageRect(image!, Offset.zero & Size(image!.width.toDouble(), image!.height.toDouble()), Offset.zero & size, bgPaint);

      double startX = size.width * startRatio;
      double startY = 100.w;
      double clockSize = 100.w;
      var getBlockPath = _getBlockPath(startX,startY,clockSize);
      canvas.drawPath(getBlockPath, mPaint);
      mPaint.style = PaintingStyle.stroke;
      mPaint.color = Colours.white;
      canvas.drawPath(getBlockPath, mPaint);

      mPaint.style = PaintingStyle.fill;
      mPaint.color = Colours.black.withOpacity(0.6);
      canvas.drawPath(getBlockPath, mPaint);
      double wSize = image!.width.toDouble() * (clockSize/size.width);
      double hSize = image!.height.toDouble() * (clockSize/size.height);
      double offsetx = image!.width.toDouble() * (startX/size.width);
      double offsety = image!.height.toDouble() * (startY/size.height);

      double offsetLeft = slideRatio * size.width;
      if(offsetLeft < 20.w){
        offsetLeft = 20.w;
      }

      getBlockPath = _getBlockPath(offsetLeft,startY,clockSize);
      canvas.drawImageRect(image!, Offset(offsetx,offsety) & Size(wSize, hSize), Offset(offsetLeft,startY) & Size(100.w, 100.w), bgPaint);
      canvas.drawPath(getBlockPath, bgPaint);

    }

  }

  Path _getBlockPath(double startX , double startY,double blockSize){

    var path = Path();
    path.moveTo(startX, startY);
    path.lineTo(startX + blockSize, startY);
    // path.lineTo(startX + blockSize, startY+blockSize/3);
    // path.addArc(Rect.fromCircle(center: Offset(startX + blockSize,startY+blockSize/2), radius: blockSize/6), -pi/2, pi);
    path.lineTo(startX + blockSize, startY+blockSize);
    path.lineTo(startX , startY+blockSize);
    // path.lineTo(startX , startY+blockSize/3*2);
    // path.addArc(Rect.fromCircle(center: Offset(startX ,startY+blockSize/2), radius: blockSize/6), pi/2, pi);
    // path.lineTo(startX, startY);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}
