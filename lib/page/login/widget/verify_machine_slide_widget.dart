import 'package:flutter/material.dart';
import 'package:wechat/core.dart';

import '../../../color/colors.dart';

class VerifyMachineSlideWidget extends StatefulWidget {

  ValueChanged<double> slideChange;
  VoidCallback checkChange;

  VerifyMachineSlideWidget(this.slideChange,this.checkChange,{Key? key}) : super(key: key);

  @override
  State<VerifyMachineSlideWidget> createState() => _VerifyMachineSlideWidgetState();
}

class _VerifyMachineSlideWidgetState extends State<VerifyMachineSlideWidget> {

  final GlobalKey globalKey = GlobalKey();
  double _downX = 0;
  double _left = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Center(child: Container(
          key: globalKey,
          width: double.infinity,height: 30.w,decoration: Colours.c_CCCCCC.boxDecoration(borderRadius: 12.w),)),
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onPanDown: (details){
              _downX = details.globalPosition.dx;
            },
            onPanUpdate: (details){
              _left = details.globalPosition.dx - _downX;
              double maxWidget = globalKey.currentContext!.size!.width - 100.w;
              if(_left < 0){
                _left = 0;
              }else if(_left > maxWidget){
                _left = maxWidget;
              }
              widget.slideChange.call(_left/maxWidget);
            },
            onPanEnd: (details){
              _left = 0;
              widget.checkChange.call();
              widget.slideChange.call(0);
            },
            onPanCancel: (){
              _left = 0;
              widget.slideChange.call(0);
            },
            child: Container(
              margin: EdgeInsets.only(left: _left),
              width: 100.w,
              height: 50.w,
              decoration: Colours.c_00CE3E.boxDecoration(borderRadius: 50.w),
            ),
          ),)
      ],
    );
  }
}
