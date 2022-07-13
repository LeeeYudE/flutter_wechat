// ignore_for_file: constant_identifier_names

library hb_password_input_textfield;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum HBPasswordInputTextFieldType { BOXES, SEGMENTED }

class HBPasswordInputTextField extends StatefulWidget {
  final HBPasswordInputTextFieldType type; //格子样式
  final ValueChanged<String> onChange;
  final int length; //输入长度
  final TextEditingController controller; //输入控制器
  final FocusNode node; //焦点
  final double boxWidth; //格子宽
  final double boxHeight; //格子高
  final double borderWidth; //边框宽
  final double borderRaiuds; //圆角
  final Color borderColor; //边框颜色
  final Color fillColor; //填充颜色
  final Color backgroundColor; //填充颜色
  final double spacing; //格子间隔
  final bool obscureText; //是否密文
  final String obscureTextString; //密文字符
  final TextStyle textStyle; //文本样式
  final bool readOnly;
  final GestureTapCallback? onTap;

  const HBPasswordInputTextField({
    Key? key,
    required this.onChange,
    required this.length,
    required this.controller,
    required this.node,
    required this.boxWidth,
    required this.boxHeight,
    required this.borderRaiuds,
    required this.borderColor,
    required this.spacing,
    required this.borderWidth,
    required this.obscureText,
    required this.textStyle,
    required this.obscureTextString,
    required this.type,
    required this.fillColor,
    required this.backgroundColor,
    this.readOnly = false,
    this.onTap
  }) : super(key: key);

  void clear() {}

  @override
  _HBPasswordInputTextFieldState createState() =>
      _HBPasswordInputTextFieldState();
}

class _HBPasswordInputTextFieldState extends State<HBPasswordInputTextField> {

  List titles = [];
  Widget box() {
    List<Widget> children = [];
    for (var i = 0; i < widget.length; i++) {
      String title = " ";
      if (titles.length > i) {
        title = widget.obscureText ? widget.obscureTextString : titles[i];
      }
      Border border =
      Border.all(width: widget.borderWidth, color: widget.borderColor);
      BorderRadius borderRadius = BorderRadius.circular(widget.borderRaiuds);
      double itemWidth = widget.boxWidth;
      double itemHeight = widget.boxHeight;
      if (widget.type == HBPasswordInputTextFieldType.BOXES) {
        borderRadius = BorderRadius.circular(widget.borderRaiuds);
        border =
            Border.all(width: widget.borderWidth, color: widget.borderColor);
      } else if (widget.type == HBPasswordInputTextFieldType.SEGMENTED) {
        BorderSide side =
        BorderSide(width: widget.borderWidth, color: widget.borderColor);
        Radius radius = Radius.circular(widget.borderRaiuds);
        if (i == 0) {
          itemWidth += 5;
          borderRadius = BorderRadius.only(topLeft: radius, bottomLeft: radius);
          border = Border(left: side, bottom: side, top: side, right: side);
        } else if (i == widget.length - 1) {
          itemWidth += 5;
          borderRadius =
              BorderRadius.only(topRight: radius, bottomRight: radius);
          border = Border(left: side, bottom: side, top: side, right: side);
        } else if (i == widget.length - 2) {
          border = Border(bottom: side, top: side);
        } else {
          border = Border(bottom: side, top: side, right: side);
        }
      }
      Widget item = Container(
        height: itemHeight,
        width: itemWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: widget.fillColor,
            borderRadius: borderRadius,
            border: border),
        child: Text(
          title,
          style: widget.textStyle,
        ),
      );
      children.add(item);
    }

    BoxDecoration decoration = BoxDecoration(color: widget.backgroundColor);
    return Stack(
      children: <Widget>[
        Positioned(
          left: 200,
          child: SizedBox(
            width: 10,
            // alignment: Alignment.center,
            child: TextField(
              readOnly: widget.readOnly,
              controller: widget.controller,
              focusNode: widget.node,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontSize: 0),
              maxLength: 6,
              onTap: widget.onTap,
              onChanged: (text) {
                titles = text.split("");
                widget.onChange(text);
                setState(() {});
              },
              onEditingComplete: () {},
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            widget.node.requestFocus();
          },
          child: SizedBox(
              width: double.infinity,
              child: Container(
                  width: widget.length * widget.boxWidth,
                  decoration: decoration,
                  child: widget.type == HBPasswordInputTextFieldType.BOXES
                      ? Wrap(
                    alignment: WrapAlignment.center,
                    spacing: widget.spacing,
                    children: children,
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ))),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_inputChange);
  }

  _inputChange(){
      titles = widget.controller.text.split("");
      widget.onChange(widget.controller.text);
      setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_inputChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget box1 = box();
    return Container(
      color: widget.backgroundColor,
      child: box1,
    );
  }
}
