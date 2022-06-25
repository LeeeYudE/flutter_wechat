import 'package:flutter/cupertino.dart';

class TapWidget extends StatelessWidget {

  Widget child;
  GestureTapCallback onTap;

  TapWidget({required this.child,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      behavior: HitTestBehavior.opaque,
      onTap:(){
        onTap();
      } ,
    );
  }
}
