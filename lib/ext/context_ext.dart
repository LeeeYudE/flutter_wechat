import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// @author Barry
/// @date 2020/10/20
/// describe:
extension ContextExt on BuildContext {

  Color get themeColor {
    final TargetPlatform platForm = Theme.of(this).platform;
    if (platForm == TargetPlatform.android) {
      return Theme.of(this).primaryColor;
    } else {
      return CupertinoTheme.of(this).primaryColor;
    }
  }

  double get screenWidth {
    return getScreenWidth(this);
  }

  double get screenHeight {
    return getScreenHeight(this);
  }

  double get statusHeight{
    return MediaQuery.of(this).padding.top;
  }

  /// 获取屏幕宽度
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }


}
