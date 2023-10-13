import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:wechat/utils/file_utils.dart';
import 'package:image_size_getter/file_input.dart';

class ImageUtil{

  static Future<String?> compressImage(File file,
      {int quality = 80,
        int minWidth = 720,
        int minHeight = 720,
        CompressFormat format = CompressFormat.png,
        bool autoCorrectionAngle = true}) async {
    var _dir = await FileUtils.getImageTemporaryDirectory();
    var result = await FlutterImageCompress.compressAndGetFile(
        file.path, '$_dir/${DateTime.now().millisecondsSinceEpoch}.${format == CompressFormat.png ? 'png' : 'jpg'}',
        format: format,
        quality: 80,
        keepExif: true,
        minWidth: minWidth,
        minHeight: minHeight,
        autoCorrectionAngle: autoCorrectionAngle);

    return result?.path;
  }

  static Future<Size> imageSize(File file) async {
    var asyncImageInput = AsyncImageInput.input(FileInput(file));
    final size = await ImageSizeGetter.getSizeAsync(asyncImageInput);
    return size;
  }

}