import 'package:flutter/material.dart';


extension ColorExt on String {
  Color get color {
    if (this == null) return Colors.amber;
    if (this is String) {
      try {
        String hexColor = this;
        if (hexColor.isEmpty) return Colors.amber;
        hexColor = hexColor.toUpperCase().replaceAll('#', '');
        hexColor = hexColor.replaceAll('0X', '');
        if (hexColor.length == 6) {
          hexColor = 'FF' + hexColor;
        }
        return Color(int.parse(hexColor, radix: 16));
      } catch (e) {
        print(e);
        // 'color 解析异常,异常值:$this'.debugPrint();
      }
    }
    return Colors.amber;
  }
}
