import 'package:flutter/material.dart';

import 'screen_util_ext.dart';

extension StyleExt on int {
  TextStyle textStyle(Color color, {bool bold = false}) {
    return TextStyle(
      color: color,
      fontSize: sp,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
}
