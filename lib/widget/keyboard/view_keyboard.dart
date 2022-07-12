import 'package:flutter/material.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/tap_widget.dart';
import '../../color/colors.dart';
import 'key_event.dart';
import 'keyboard_item.dart';

typedef OnPasswordCallback = void Function(String pwd);
typedef OnKeyDownCallback = void Function(KeyDownEvent event);

class CustomKeyboard extends StatefulWidget {
  final OnKeyDownCallback? onKeyDown;
  final OnPasswordCallback? onResult;
  final VoidCallback? onClose;
  final bool showDot;
  final int? pwdLength;

  const CustomKeyboard(
      {this.onKeyDown,
      this.onResult,
      this.showDot = false,
      this.onClose,
      this.pwdLength,
      Key? key})
      : super(key: key);

  @override
  _CustomKeyboardState createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  String data = '';

  double keyHeight = 100.w;
  double headHeight = 50.w;

  List<String> keyList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    'del'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.showDot) {
      keyList[9] = '.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: keyHeight * 4 + headHeight+1.w,
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          pwdWidget(),
          Colours.c_EEEEEE.toLine(1.w),
          keyboardWidget(),
        ],
      ),
    );
  }

  Widget pwdWidget() {
    return Container(
      width: double.infinity,
      height: headHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Center(child: TapWidget(onTap: () {
            widget.onClose?.call();
          },
          child: const Icon(Icons.keyboard_arrow_down,color: Colours.c_999999,)),
          ),
        ],
      ),
    );
  }

  Widget keyboardWidget() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      height: 4 * keyHeight,
      child: Wrap(
        children: keyList.map((item) {
          return KeyboardItem(
            keyHeight: keyHeight,
            text: item,
            callback: () => onKeyDown(context, item),
          );
        }).toList(),
      ),
    );
  }

  void onKeyDown(BuildContext context, String text) {

    if ('del' == text && data.isNotEmpty) {
      data = data.substring(0, data.length - 1);
      widget.onKeyDown?.call(KeyDownEvent(text));
      return;
    }
    if (widget.pwdLength != null && data.length >= widget.pwdLength!) {
      return;
    }
    widget.onKeyDown?.call(KeyDownEvent(text));
    data += text;
    if (data.length == widget.pwdLength && widget.showDot) {
      widget.onResult!(data);
    }
  }
}
