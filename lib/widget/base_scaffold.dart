import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../color/colors.dart';
import 'package:wechat/core.dart';

class MyScaffold extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? child;
  final Widget? leading;
  final Widget? body;
  final Color? appbarColor;
  final Color? backgroundColor;
  final Widget? titleWidget;
  final Widget? floatingActionButton;
  final Brightness? brightness;
  final bool resizeToAvoidBottomInset;
  final bool showLeading;
  final bool showAppbar;
  final IconData? backIcon;
  final Widget? bottomNavigationBar;
  final VoidCallback? onBodyClick;
  final Color? backIconColor;

   const MyScaffold({
    Key? key,
    this.title,
    this.actions,
    this.leading,
    this.brightness,
    this.body,
    this.appbarColor,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = false,
    this.child,
    this.titleWidget,
    this.floatingActionButton,
    this.showLeading = true,
    this.showAppbar = true,
    this.backIcon,
    this.bottomNavigationBar,
    this.onBodyClick,
    this.backIconColor
  }) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      appBar: showAppbar?AppBar(
        //状态栏颜色
        brightness: brightness ?? Brightness.dark,
        centerTitle: true,
        backgroundColor: appbarColor??Colours.c_EEEEEE,
        automaticallyImplyLeading: false,
        title: _buildCustomTitle(context),
        leadingWidth: 0.0,
        elevation: 0,
      ):null,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onBodyClick??() => FocusManager.instance.primaryFocus!.unfocus(),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar:bottomNavigationBar ,
    );
  }

  Widget _buildCustomTitle(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: titleWidget??Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if(child != null)
            child!,
          Align(
            alignment: Alignment.centerLeft,
            child: Offstage(
              offstage: !showLeading,
              child: leading??IconButton(
                icon: Icon(backIcon??Icons.arrow_back_ios,color: backIconColor??Colours.black,), onPressed: () {
                Get.back();
              },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: (Container(
              constraints: BoxConstraints(
                  maxWidth: 400.w
              ),
              child: Text(title ?? '', style: TextStyle(fontSize: 32.sp, color: backIconColor??Colors.black, decoration: TextDecoration.none,fontWeight: FontWeight.w500)),
            )
            ),
          ),
          if (actions != null)
            Align(
              alignment: Alignment.centerRight,
              child: Row(children: actions!, mainAxisSize: MainAxisSize.min),
            )
        ],
      ),
    );
  }

}
