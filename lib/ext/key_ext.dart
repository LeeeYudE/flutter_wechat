import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:wechat/core.dart';
import '../language/strings.dart';
import '../utils/permission_utils.dart';

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

  ///判断位置是否在当前控件里面
  bool includeOffset(Offset otherOffset) {
    final RenderBox renderBox = currentContext?.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    if(otherOffset.dx > offset.dx && otherOffset.dx < offset.dx + size.width &&
        otherOffset.dy > offset.dy && otherOffset.dy < offset.dy + size.height){
      return true;
    }
    return false;
  }

  /// 获取截取图片的数据
  Future<Uint8List?> _getImageData(GlobalKey repaintKey) async {
    BuildContext? buildContext = repaintKey.currentContext;
    if (buildContext != null) {
      RenderRepaintBoundary? boundary = buildContext.findRenderObject() as RenderRepaintBoundary?;
      // 获取当前设备的像素比
      double dpr = ui.window.devicePixelRatio;
      // pixelRatio 代表截屏之后的模糊程度，因为不同设备的像素比不同
      // 定义一个固定数值显然不是最佳方案，所以以当前设备的像素为目标值
      ui.Image image = await boundary!.toImage(pixelRatio: dpr);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if(byteData != null){
        Uint8List imageBytes = byteData.buffer.asUint8List();
        return imageBytes;
      }
      // 返回图片的数据
    }
    return null;
  }

  /// 执行存储图片到本地相册
  /// ///https://blog.csdn.net/Android_XG/article/details/125335221
  void doSaveImage() async {
    // 如果用户已授权存储权限
    var bool = await PermissionUtils.requestPermissionStorage();
    if(bool){
      Uint8List? data = await _getImageData(this);
      if(data != null){
        var saveImage =  await ImageGallerySaver.saveImage(data);
        if(saveImage['isSuccess'] == true){
          Ids.save_success.str().toast();
        }
      }
    }else{
      Ids.no_permission.str().toast();
    }
  }

}
