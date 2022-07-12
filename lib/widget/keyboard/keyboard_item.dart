import 'package:flutter/material.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../color/colors.dart';
import '../../language/strings.dart';


class KeyboardItem extends StatefulWidget {
  final String? text;
  final GestureTapCallback callback;
  final double? keyHeight;

  const KeyboardItem({Key? key,required this.callback, this.text, this.keyHeight}) : super(key: key);

  @override
  ButtonState createState() => ButtonState();
}

class ButtonState extends State<KeyboardItem> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final _screenWidth = mediaQuery.size.width;

    return TapWidget(
      onTap: widget.callback,
      child: Container(
        height: widget.keyHeight,
        decoration: BoxDecoration(
            color: (widget.text == '.' || widget.text == 'del')?Colours.c_f0f0f0:Colours.white,
            border:Border(
                bottom: BorderSide(
                    color: Colours.c_EEEEEE,
                    width: 1.w
                ),
              right: BorderSide(
                  color: Colours.c_EEEEEE,
                  width: 1.w
              ),
            )
        ),
        width: _screenWidth / 3,
        child: Center(
          child: widget.text == 'del'?const Icon(Icons.delete) :Text(
            (widget.text == 'del') ?Ids.delete.str() : widget.text!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 38.sp,
              color: Colours.black
            ),
          ),
        ),
      ),
    );
  }
}