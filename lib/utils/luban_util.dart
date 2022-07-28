import 'dart:io';

import 'package:flutter_luban/flutter_luban.dart';
import 'package:wechat/utils/file_utils.dart';

class LubanUtil{

  static Future<String?> compress(File file) async {
    var _dir = await FileUtils.getImageTemporaryDirectory();
    CompressObject compressObject = CompressObject(
      imageFile:file, //image
      path:_dir.path, //compress to path
      quality: 85,//first compress quality, default 80
      step: 9,//compress quality step, The bigger the fast, Smaller is more accurate, default 6
      mode: CompressMode.LARGE2SMALL,//default AUTO
    );
    var image = await Luban.compressImage(compressObject);
    return image;
  }

}