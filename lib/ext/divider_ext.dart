import 'package:flutter/material.dart';

import 'screen_util_ext.dart';

extension DividerExt on double {
  Widget dividerH({Color color = const Color(0XFFE1E1E1)}) {
    return Divider(
      height: h,
      color: color,
    );
  }
}
