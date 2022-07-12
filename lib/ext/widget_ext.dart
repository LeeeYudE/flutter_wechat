

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

extension ScrollControllerExt on ScrollController{


  animateToBottom({int milliseconds = 300}){
    final maxScrollExtent = position.maxScrollExtent;
    animateTo(
      maxScrollExtent,
      curve: Curves.linear,
      duration: Duration(milliseconds: milliseconds),
    );
  }

}


extension TextEditingControllerExt on TextEditingController{

  void insertText(String text) {
    final TextEditingValue value = this.value;
    final int start = value.selection.baseOffset;
    int end = value.selection.extentOffset;
    if (value.selection.isValid && value.text.isNotEmpty) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
        end = start;
      }
      this.value = value.copyWith(
          text: newText,
          selection: value.selection.copyWith(
              baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      newValue(text);
    }
  }

  newValue(String text){
    value = TextEditingValue(
        text: text,
        selection:
        TextSelection.fromPosition(TextPosition(offset: text.length)));
  }

  removeLastText(){
    final TextEditingValue value = this.value;
    final int start = value.selection.baseOffset;
    int end = value.selection.extentOffset;
    if (value.selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end-1);
        }
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.substring(end, value.text.length-1);
        end = start;
      }

      this.value = value.copyWith(
          text: newText,
          selection: TextSelection.fromPosition(TextPosition(offset: start - 1)));
    } else {
      newValue(text);
    }
  }

}

extension FocusNodeExt on FocusNode{

  void showkeyboard(){
    if(context == null){
      return;
    }
    if (hasFocus) {
      _showkeyboard();
    } else {
      FocusScope.of(context!).requestFocus(this);
    }
  }

  _showkeyboard() {
    SystemChannels.textInput
        .invokeMethod<void>('TextInput.show')
        .whenComplete(() {});
  }


}