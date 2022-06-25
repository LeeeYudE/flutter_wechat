import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';

class MainAppbar extends StatefulWidget {
  const MainAppbar({Key? key}) : super(key: key);

  @override
  State<MainAppbar> createState() => _MainAppbarState();
}

class _MainAppbarState extends State<MainAppbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.c_EEEEEE,
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: Container(
        height: 100.w,
        child: Stack(
          children: [
            Center(child: Text('测试'),)
          ],
        ),
      ),
    );
  }
}
