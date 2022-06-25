import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.theme_color_4,
    );
  }
}
