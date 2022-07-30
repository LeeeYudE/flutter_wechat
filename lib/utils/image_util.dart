import 'dart:io';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:wechat/utils/file_utils.dart';
import 'package:image_size_getter/file_input.dart';

class ImageUtil{

  static Future<String?> compressImage(File file) async {
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

  static Future<Size> imageSize(File file) async {
    var asyncImageInput = AsyncImageInput.input(FileInput(file));
    final size = await ImageSizeGetter.getSizeAsync(asyncImageInput);
    return size;
  }

}