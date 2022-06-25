import 'package:flutter/material.dart';
class SlideTransitionRoute extends PageRouteBuilder{

  static const DIRECTION_LEFT = 0;
  static const DIRECTION_BOTTOM = 1;
  static const DIRECTION_RIGHT = 2;
  static const DIRECTION_TOP = 3;

  final Widget widget;
  final int  direction;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  SlideTransitionRoute(this.widget,{this.direction = DIRECTION_LEFT})
      :super(
    // 设置过度时间
      transitionDuration:const Duration(milliseconds: 250),
      // 构造器
      pageBuilder:(
          // 上下文和动画
          BuildContext context,
          Animation<double> animaton1,
          Animation<double> animaton2,
          ){
        return widget;
      },
      transitionsBuilder:(
          BuildContext context,
          Animation<double> animaton1,
          Animation<double> animaton2,
          Widget child,
          ){

        // 需要什么效果把注释打开就行了
        // 渐变效果
        // return FadeTransition(
        //   // 从0开始到1
        //   opacity: Tween(begin: 0.0,end: 1.0)
        //       .animate(CurvedAnimation(
        //     // 传入设置的动画
        //     parent: animaton1,
        //     // 设置效果，快进漫出   这里有很多内置的效果
        //     curve: Curves.fastOutSlowIn,
        //   )),
        //   child: child,
        // );

        // 缩放动画效果
        // return ScaleTransition(
        //   scale: Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
        //     parent: animaton1,
        //     curve: Curves.fastOutSlowIn
        //   )),
        //   child: child,
        // );

        // 旋转加缩放动画效果
        // return RotationTransition(
        //   turns: Tween(begin: 0.0,end: 1.0)
        //   .animate(CurvedAnimation(
        //     parent: animaton1,
        //     curve: Curves.fastOutSlowIn,
        //   )),
        //   child: ScaleTransition(
        //     scale: Tween(begin: 0.0,end: 1.0)
        //     .animate(CurvedAnimation(
        //       parent: animaton1,
        //       curve: Curves.fastOutSlowIn
        //     )),
        //     child: child,
        //   ),
        // );

        // 左右滑动动画效果
        return SlideTransition(
          position: Tween<Offset>(
            // 设置滑动的 X , Y 轴
              begin: Offset((DIRECTION_LEFT == direction)? -1.0: (DIRECTION_RIGHT == direction)? 1 : 0, (DIRECTION_BOTTOM == direction)? 1.0:0),
              end: const Offset(0.0,0.0)
          ).animate(CurvedAnimation(
              parent: animaton1,
              curve: Curves.ease
          )),
          child: child,
        );
      }
  );
}