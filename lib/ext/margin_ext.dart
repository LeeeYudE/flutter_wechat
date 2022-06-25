import 'package:flutter/material.dart';

import 'screen_util_ext.dart';

extension MarginIntExt on int {
  EdgeInsetsGeometry marginHorizontal() {
    return EdgeInsets.symmetric(horizontal: w);
  }

  EdgeInsetsGeometry marginVertical() {
    return EdgeInsets.symmetric(vertical: h);
  }

  EdgeInsetsGeometry marginLeft() {
    return EdgeInsets.only(left: w);
  }

  EdgeInsetsGeometry marginRight() {
    return EdgeInsets.only(right: w);
  }

  EdgeInsetsGeometry marginTop() {
    return EdgeInsets.only(top: h);
  }

  EdgeInsetsGeometry marginBottom() {
    return EdgeInsets.only(bottom: h);
  }
  EdgeInsetsGeometry marginAll() {
    return EdgeInsets.all(h);
  }

  EdgeInsetsGeometry marginHV(int vertical) {
    return EdgeInsets.symmetric(horizontal: h, vertical: vertical.h);
  }
}
