import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';

import '../controller/red_packet_controller.dart';

class RedPacketTopBg extends CustomPainter{

  late final Paint _paint = Paint()..isAntiAlias = true;
  final Path path = Path();

  late double height = 1.2.sw;
  late double topBezierEnd = 300.w;
  late double topBezierStart= 100.w;

  Offset goldCenter = Offset.zero;
  final double centerWidth = 0.5.sw;

  late double left = -0.1.sw;
  late double right = 1.1.sw;
  late double top = 0;
  late double bottom = 300.w;

  RedPacketTopBg() : super();


  @override
  void paint(Canvas canvas, Size size) {
    drawBg(canvas);
  }

  void drawBg(ui.Canvas canvas) {

    _paint.color = Colors.redAccent;
    _paint.style = PaintingStyle.fill;
    drawTop(canvas);
  }


  void drawTop(ui.Canvas canvas) {
    canvas.save();
    path.reset();
    path.addRect(Rect.fromLTRB(0, 100.w, 1.0.sw, 0));

    var bezierPath = getTopBezierPath();
    path.addPath(bezierPath, Offset.zero);
    path.close();

    canvas.drawShadow(path, Colours.c_FA9E3B, 5.w, true);
    canvas.drawPath(path, _paint);
    canvas.restore();
  }

  Path getTopBezierPath() {
    Path bezierPath = Path();
    bezierPath.moveTo(left, topBezierStart);
    bezierPath.quadraticBezierTo(centerWidth, topBezierEnd, right , topBezierStart);

    var pms = bezierPath.computeMetrics();
    var pm = pms.first;
    goldCenter = pm.getTangentForOffset(pm.length / 2)?.position ?? Offset.zero;
    return bezierPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}