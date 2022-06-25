import 'package:flutter/cupertino.dart';
import 'screen_util_ext.dart';

extension DecorationColorExt on Color {

  Widget toLine(double height){
    return Container(color: this,height: height,width: double.infinity,);
  }

  Decoration boxDecoration({double? borderRadius}){
    return BoxDecoration(color: this, borderRadius:borderRadius != null ? BorderRadius.circular(borderRadius):BorderRadius.zero,);
  }

  Decoration borderDecoration({double? borderRadius,double width = 2}){
    return BoxDecoration(borderRadius:borderRadius != null ? BorderRadius.circular(borderRadius):BorderRadius.zero, border:Border.all(color: this, width: width.w),
    );
  }
  Decoration radiusDecoration({ double? topLeft , double? topRight, double? bottomLeft , double? bottomRight }){
    return BoxDecoration(
        color: this,
        borderRadius:BorderRadius.only(
            topLeft: topLeft != null ? Radius.circular(topLeft) : Radius.zero,
            topRight: topRight != null ? Radius.circular(topRight) : Radius.zero,
            bottomLeft: bottomLeft != null ? Radius.circular(bottomLeft) : Radius.zero,
            bottomRight: bottomRight != null ? Radius.circular(bottomRight) : Radius.zero
        ),
    );
  }

}

extension DecorationExt on int {
  Decoration topLeftRightDecoration(Color color) {
    return ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(w), topRight: Radius.circular(w))));
  }

  Decoration leftDecoration(Color color) {
    return ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(w), topLeft: Radius.circular(w))));
  }

  Decoration roundedDecoration(Color color) {
    return ShapeDecoration(
        color: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(w))));
  }

  BoxDecoration boxDecoration(Color bgColor, {Color borderColor = const Color(0XFFE1E1E1), double borderWith = 0.5}) {
    return BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(w)),
        border: Border.all(color: borderColor, width: borderWith),
        color: bgColor);
  }

  BoxDecoration boxBorder({Color? borderColor, double borderWith = 0.5, Color? bgColor}) {
    return BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(w)),
        border: Border.all(color: borderColor ?? const Color(0XFF000000), width: borderWith),
        color: bgColor);
  }
}
