import 'package:flustars/flustars.dart';

class ScreenUtilExt {
  static double setHeight(num height) {
    // if(!BaseConfig.pad){
    //   return setWidth(height);
    // }
    return ScreenUtil.getInstance().getHeight(height.toDouble());
  }

  static double setWidth(num width) {
    return ScreenUtil.getInstance().getWidth(width.toDouble());
  }

  static double setSp(num fontSize, {bool? allowFontScalingSelf}) =>
      ScreenUtil.getInstance().getSp(fontSize.toDouble());

  static double getHeight() {
    return ScreenUtil.getInstance().screenHeight;
  }

  static double getWidth() {
    return ScreenUtil.getInstance().screenWidth;
  }
}

extension DensityIntExt on num {
  double get w {
    return ScreenUtilExt.setWidth(toDouble());
  }

  double get h {
    return ScreenUtilExt.setHeight(toDouble());
  }

  double get sp {
    return ScreenUtilExt.setSp(this);
  }
}

extension DensityDoubleExt on double {
  double get w {
    return ScreenUtilExt.setWidth(this);
  }

  double get h {
    return ScreenUtilExt.setHeight(this);
  }

  double get sp {
    return ScreenUtil.getInstance().getSp(this);
  }


  ///屏幕宽度的倍数
  ///Multiple of screen width
  double get sw => ScreenUtil.getInstance().screenWidth * this;

  ///屏幕高度的倍数
  ///Multiple of screen height
  double get sh => ScreenUtil.getInstance().screenHeight * this;

}
