import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/widget/tap_widget.dart';
import '../color/colors.dart';
import 'package:wechat/core.dart';

import '../page/main/chat/widget/my_special_text_span_builder.dart';

class InputField extends StatefulWidget {

  final String? hint;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final bool showClean;
  final Widget? leftWidget;
  final bool autofocus;
  final bool extended;
  final bool showDecoration;
  final FocusNode? focusNode;
  final bool? readOnly;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;
  final TextAlign? textAlign;
  final int? lengthLimiting;
  final EdgeInsetsGeometry? padding;
  final TextInputFormatter? inputFormatter;

  InputField({this.hint,this.inputType,this.controller,this.leftWidget,this.showClean = false,this.autofocus = true,this.showDecoration = true,this.focusNode,this.extended = false,this.onSubmitted,this.readOnly,this.onTap,this.textAlign,this.lengthLimiting,this.padding,this.inputFormatter,Key? key}) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {

  bool _isShowClean = false;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller!.addListener(() {
      if(mounted && widget.showClean){
        bool isShowClean = _controller!.text.isNotEmpty;
        if(isShowClean != _isShowClean){
          setState(() {
            _isShowClean = isShowClean;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.showDecoration?Colours.white.boxDecoration(borderRadius: 12.w):null,
      padding: widget.padding??EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.w),
      child: Row(
        children: [
          if(widget.leftWidget != null)
            Container(
                margin: EdgeInsets.only(right: 10.w),
                child: widget.leftWidget!),
          Expanded(
            child: widget.extended?
            ExtendedTextField(
              textAlign: widget.textAlign??TextAlign.start,
              readOnly: widget.readOnly??false,
              showCursor: true,
              controller: _controller,
              autocorrect: false,
              focusNode: widget.focusNode,
              style: TextStyle(color: Colours.black,fontSize: 32.sp,textBaseline: TextBaseline.alphabetic),
              maxLines: null,
              decoration:  InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5.w),
                hintText: widget.hint,
                hintStyle: TextStyle(color: Colours.c_999999,fontSize: 32.sp,height: 1.0),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              specialTextSpanBuilder: MySpecialTextSpanBuilder(showAtBackground: false),
              onSubmitted: widget.onSubmitted,
              onTap: widget.onTap,
              inputFormatters: <TextInputFormatter>[
                if(widget.lengthLimiting != null)
                LengthLimitingTextInputFormatter(widget.lengthLimiting),//限制长度
                if(widget.inputFormatter != null)
                  widget.inputFormatter!
              ]
            ) : TextField(
              readOnly: widget.readOnly??false,
              showCursor: true,
              autofocus: widget.autofocus,
              textAlign: widget.textAlign??TextAlign.start,
              style: TextStyle(color: Colours.black,fontSize: 32.sp, ),
              focusNode: widget.focusNode,
              decoration:  InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5.w),
                hintText: widget.hint,
                hintStyle: TextStyle(color: Colours.c_999999,fontSize: 32.sp,height: 1.0),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              keyboardType: widget.inputType,
              controller: widget.controller,
              onSubmitted: widget.onSubmitted,
              onTap: widget.onTap,
              inputFormatters: <TextInputFormatter>[
                if(widget.lengthLimiting != null)
                  LengthLimitingTextInputFormatter(widget.lengthLimiting),//限制长度
                if(widget.inputFormatter != null)
                  widget.inputFormatter!
              ]
            ),
          ),
          if(_isShowClean)
            _buildCancelButton()
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return TapWidget(
      child: Container(
        margin: EdgeInsets.only(left: 10.w,right: 10.w),
        padding:EdgeInsets.only(bottom: 5.h) ,
        child: Icon(Icons.cancel, size: 34.w, color: Colours.c_999999),
      ),
      onTap: () {
        // 保证在组件build的第一帧时才去触发取消清空内
        WidgetsBinding.instance?.addPostFrameCallback((_) => _controller!.clear());
        setState(() {
          _isShowClean = false;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if(widget.controller == null){
      _controller?.dispose();
    }
  }

}
