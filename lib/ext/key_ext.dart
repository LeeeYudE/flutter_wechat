import 'package:flutter/widgets.dart';

extension KeyExt on GlobalKey {

  ///获得控件正下方的坐标：
  Offset? centerOffset() {
    final RenderBox? renderBox =
    currentContext?.findRenderObject() as RenderBox?;
    final Offset? offset = renderBox?.localToGlobal(Offset(renderBox.size.width/2, renderBox.size.height/2));
    return offset;
  }

  ///获得控件正下方的坐标：
  Offset?  location({bool hasOffset = true}) {
    final RenderBox? renderBox =
    currentContext?.findRenderObject() as RenderBox?;
    final Offset? offset = renderBox?.localToGlobal(
        hasOffset? Offset(renderBox.size.width, renderBox.size.height):Offset.zero);
    return offset;
  }

  ///判断控件的位置是否在当前控件里面
  bool includeWidget(GlobalKey otherGlobalKey) {

    RenderBox otherRenderBox = otherGlobalKey.currentContext?.findRenderObject() as RenderBox;

    final Offset otherOffset = otherRenderBox.localToGlobal(Offset(otherRenderBox.size.height/2, otherRenderBox.size.height/2));

    final RenderBox renderBox = currentContext?.findRenderObject() as RenderBox;
    // final Offset? offset = renderBox?.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    if(otherOffset.dx > offset.dx && otherOffset.dx < offset.dx + size.width &&
        otherOffset.dy > offset.dy && otherOffset.dy < offset.dy + size.height){
      print('otherOffset ${otherOffset.dy}');
      return true;
    }

    return false;
  }

}
