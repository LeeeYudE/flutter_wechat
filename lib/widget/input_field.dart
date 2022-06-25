import 'package:flutter/material.dart';
import '../color/colors.dart';
import 'package:wechat/core.dart';

class InputField extends StatefulWidget {

  String? hint;
  TextInputType? inputType;
  TextEditingController? controller;

  InputField({this.hint,this.inputType,this.controller,Key? key}) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colours.black,fontSize: 32.sp),
      decoration:  InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: Colours.c_999999,fontSize: 32.sp),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
        border: const UnderlineInputBorder(borderSide: BorderSide.none),
      ),
      keyboardType: widget.inputType,
      controller: widget.controller,
    );
  }
}
