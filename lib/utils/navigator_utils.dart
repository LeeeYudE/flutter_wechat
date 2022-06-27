import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../route/slide_transition_route.dart';
import '../route/transparent_rounter.dart';
import '../widget/dialog/dialog_bottom_layout.dart';
import '../widget/dialog/dialog_bottom_widget.dart';

class NavigatorUtils{

  ///打开一个新路由，跟原生pushNamed一样效果
  static Future<T?>? toNamed<T>(String routeName, {dynamic arguments}) {
    return Get.toNamed<T>(routeName, arguments: arguments);
  }

  ///清除之前的页面路由，并替换新的页面
  static Future<T?>? offAllNamed<T>(String routeName, {dynamic arguments}) {
    return Get.offAllNamed(routeName, arguments: arguments);
  }

  ///删除当前路由，并替换新的页面
  static Future? offNamed(String routeName, {dynamic arguments}) {
    return Get.offNamed(routeName, arguments: arguments);
  }

  static Future? offPage(Widget page, {dynamic arguments}) {
    return Get.off(page, arguments: arguments);
  }

  static Future? toPage(Widget page, {dynamic arguments}) {
    return Get.to(page, arguments: arguments);
  }

  static Future pushTransparentPage(BuildContext? context, Widget page, {String? pageName, Route? route , int? direction}) async {
    if (context == null) return;
    debugPrint('Navigator : pushTransparentPage => $pageName');
    Route? builder;
    if(direction != null){
      builder = SlideTransitionRoute(page, direction: direction);
    }else{
      if (route == null) {
        builder = TransparentRoute(builder: (ctx) => page);
      }
    }
    return Navigator.push(
      context,
      route ?? builder!,
    );
  }

  static void pop<T extends Object>([T? result]) {
    return Get.back(result: result);
  }

  static Future<T?> showCommonDialog<T>(Widget dialog, {bool barrierDismissible = false,}) {
    return Get.generalDialog<T>(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return dialog;
      },
    );
  }

  static Future<T?> showBottomDialog<T>(Widget dialog, {bool barrierDismissible = false,}) {
    return Get.generalDialog<T>(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return DialogBottomLayout(dialog);
      },
    );
  }

  static Future<T?> showBottomItemsDialog<T>(List<DialogBottomWidgetItem> list, {bool barrierDismissible = false,}) {
    return showBottomDialog(DialogBottomWidget(list));
  }

}