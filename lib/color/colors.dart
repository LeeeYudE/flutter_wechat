import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../base/constant.dart';

class Colours {

  static final List<Color> themeList = [theme_color,theme_color_2,theme_color_3,theme_color_4,theme_color_5];
  static int themeIndex = 0;

  static init() async {
    themeIndex = SpUtil.getInt(Constant.SP_COLOR_THEME,defValue: 0)!;
  }

  static changeThemeColor(int index){
   if(themeIndex != index){
     themeIndex = index;
     Get.changeTheme(themeData());
     SpUtil.putInt(Constant.SP_COLOR_THEME,themeIndex);
   }
  }

  static Color currentColor() => themeList[themeIndex];
  static Color primaryColor(BuildContext context) => Theme.of(context).primaryColor;


  static ThemeData themeData(){
    var color = currentColor();
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: color,
      platform: TargetPlatform.iOS,
      scaffoldBackgroundColor:c_EEEEEE,
      focusColor: color,
      cursorColor: color,
      dividerColor: color,
      hoverColor: color,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(color: color),iconColor: color,fillColor: color,hoverColor: color,focusColor: color),
      textTheme:  TextTheme(
        bodyText1: TextStyle(color: color),
      ),
      textSelectionTheme:  TextSelectionThemeData(cursorColor: color),
      // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(secondary: Colors.greenAccent, brightness: Brightness.dark),
    );
  }


  static const Color theme_color = Color(0xFF07C160);
  static const Color theme_color_2 = Color(0xffFF4E32);
  static const Color theme_color_3 = Color(0xFFf7418c);
  static const Color theme_color_4 = Color(0xff1296db);
  static const Color theme_color_5 = Color(0xFFFED648);


  static const Color line = Color(0xFFEEEEEE);
  static const Color order_line = Color(0xFFFFEBCE);
  static const Color me_text_label = Color(0xFFDDDDDD);
  static const Color text_red = Color(0xFFFF4759);

  static const Color login_text_disabled = Color(0xFFD4E2FA);
  static const Color login_button_disabled = Color(0xFF96BBFA);

  static const Color club_bg_color = Color(0xFF0a0a14);
  static const Color discover_item_color = Color(0xFF161623);

  static const Color discover_like_bar_color = Color(0xFF2E2E3A);
  static Color black_transparent = Colors.black.withOpacity(0.6);
  static Color white_transparent = Colors.white.withOpacity(0.6);

  static const Color white = Color(0xffffffff); //暗黑系版按钮背景色
  static const Color black = Color(0xff000000); //暗黑系版按钮背景色
  static const Color transparent = Color(0x00000000);

  static const Color c_301F0F = Color(0xff301F0F);
  static const Color c_5F452D = Color(0xff5F452D);
  static const Color c_5B3D21 = Color(0xff5B3D21);
  static const Color c_6C4D30 = Color(0xff6C4D30);
  static const Color c_C2B089 = Color(0xffC2B089);
  static const Color c_3B2A1A = Color(0xff3B2A1A);
  static const Color c_FF4E32 = Color(0xffFF4E32);
  static const Color c_ffffff = Color(0xffffffff);
  static const Color c_E37A18 = Color(0xffE37A18);
  static const Color c_635338 = Color(0xff635338);
  static const Color c_FF0000 = Color(0xffFF0000);
  static const Color c_00000000 = Color(0x00000000);
  static const Color c_000000 = Color(0xff000000);
  static const Color c_ECC545 = Color(0xffECC545);
  static const Color c_22180D = Color(0xFF22180D);
  static const Color c_CCCCCC = Color(0xFFCCCCCC);
  static const Color c_00CE3E = Color(0xFF00CE3E);
  static const Color c_5A3E26 = Color(0xFF5A3E26);
  static const Color c_999999 = Color(0xFF999999);
  static const Color c_EEEEEE = Color(0xFFEEEEEE);
  static const Color c_555555 = Color(0xFF555555);
  static const Color c_666666 = Color(0xFF666666);
  static const Color c_FED648 = Color(0xFFFED648);
  static const Color c_E73E24 = Color(0xFFE73E24);
  static const Color c_c4c4c4 = Color(0xFFc4c4c4);
  static const Color c_664f39 = Color(0xFF664F39);
  static const Color c_F7F7F7 = Color(0xFFF7F7F7);


  static const Color c_FFCE18 = Color(0xFFFFCE18);
  static const Color c_212129 = Color(0xFF212129);
  static const Color c_4E8DF4 = Color(0xFF4E8DF4);
  static const Color c_EF5A42 = Color(0xFFEF5A42);
  static const Color c_F77321 = Color(0xFFF77321);
  static const Color c_41EC66 = Color(0xFF41EC66);
  static const Color c_9295AD = Color(0xFF9295AD);
  static const Color c_C9CBD9 = Color(0xFFC9CBD9);
  static const Color c_F1F7F7 = Color(0xFFF1F7F7);
  static const Color c_696969 = Color(0xFF696969);
  static const Color c_484848 = Color(0xFF484848);
  static const Color c_4B4C52 = Color(0xFF4B4C52);
  static const Color c_4486F4 = Color(0xFF4486F4);
  static const Color c_FF9900 = Color(0xFFFF9900);
  static const Color c_F86800 = Color(0xFFF86800);
  static const Color c_E9465D = Color(0xFFE9465D);
  static const Color c_291C10 = Color(0xFF291C10);
  static const Color c_E5A55A = Color(0xFFE5A55A);
  static const Color c_211305 = Color(0xFF211305);
  static const Color c_E7C856 = Color(0xFFE7C856);
  static const Color c_E63E24 = Color(0xFFE63E24);
  static const Color c_825F3F = Color(0xFF825F3F);
  static const Color c_5f452c = Color(0xFF5f452c);
  static const Color c_23170B = Color(0xFF23170B);
  static const Color c_FF5C00 = Color(0xFFFF5C00);
  static const Color c_0D1807 = Color(0xFF0D1807);
  static const Color c_CCE6FF = Color(0xFFCCE6FF);
  static const Color c_BABABA = Color(0xFFBABABA);
  static const Color c_E65324 = Color(0xFFE65324);
  static const Color c_2F1D0D = Color(0xFF2F1D0D);
  static const Color c_D48610 = Color(0xFFD48610);
  static const Color c_0066FF = Color(0xFF0066FF);
  static const Color c_FF9B63 = Color(0xFFFF9B63);
  static const Color c_63A1FF = Color(0xFF63A1FF);
  static const Color c_5B6B8D = Color(0xFF5B6B8D);
  static const Color c_98E165 = Color(0xFF98E165);
  static const Color c_f0f0f0 = Color(0xFFf0f0f0);
  static const Color c_FA9E3B = Color(0xFFFA9E3B);
  static const Color c_FCE5BF = Color(0xFFFCE5BF);

  static const Color line_color = Color(0xFFA3A3A4);


}
